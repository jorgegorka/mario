require "English"
require "json"
require_relative "output"
require_relative "frontmatter"

module MarketingMario
  module Tools
    module Verification
      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "plan-structure"
          verify_plan_structure(argv.first, raw: raw)
        when "references"
          verify_references(argv.first, raw: raw)
        when "commits"
          verify_commits(argv, raw: raw)
        when "artifacts"
          verify_artifacts(argv.first, raw: raw)
        when "key-links"
          verify_key_links(argv.first, raw: raw)
        else
          Output.error("Unknown verify subcommand. Available: plan-structure, references, commits, artifacts, key-links")
        end
      end

      def self.validate_dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "consistency"
          validate_consistency(raw: raw)
        else
          Output.error("Unknown validate subcommand. Available: consistency")
        end
      end

      def self.verify_summary(argv, raw: false)
        summary_path = argv.shift
        Output.error("summary-path required") unless summary_path

        count_idx = argv.index("--check-count")
        check_count = count_idx ? argv[count_idx + 1].to_i : 2

        cwd = Dir.pwd
        full_path = File.join(cwd, summary_path)

        unless File.exist?(full_path)
          result = {
            passed: false,
            checks: {
              summary_exists: false,
              files_created: { checked: 0, found: 0, missing: [] },
              commits_exist: false,
              self_check: "not_found"
            },
            errors: ["SUMMARY.md not found"]
          }
          Output.json(result, raw: raw, raw_value: "failed")
          return
        end

        content = File.read(full_path)
        errors = []

        # Spot-check files mentioned in summary
        mentioned_files = []
        patterns = [
          /`([^`]+\.[a-zA-Z]+)`/,
          /(?:Created|Modified|Added|Updated|Edited):\s*`?([^\s`]+\.[a-zA-Z]+)`?/i
        ]

        patterns.each do |pattern|
          content.scan(pattern) do |match|
            file_path = match[0]
            if file_path && !file_path.start_with?("http") && file_path.include?("/") && !mentioned_files.include?(file_path)
              mentioned_files << file_path
            end
          end
        end

        files_to_check = mentioned_files.first(check_count)
        missing = files_to_check.reject { |f| File.exist?(File.join(cwd, f)) }

        # Check commits exist
        hashes = content.scan(/\b[0-9a-f]{7,40}\b/)
        commits_exist = false
        if hashes.any?
          hashes.first(3).each do |hash|
            result = exec_git(cwd, ["cat-file", "-t", hash])
            if result[:exit_code].zero? && result[:stdout].strip == "commit"
              commits_exist = true
              break
            end
          end
        end

        # Self-check section
        self_check = "not_found"
        if content.match?(/##\s*(?:Self[- ]?Check|Verification|Quality Check)/i)
          check_section = content[content.index(/##\s*(?:Self[- ]?Check|Verification|Quality Check)/i)..]
          if check_section.match?(/(?:fail|✗|❌|incomplete|blocked)/i)
            self_check = "failed"
          elsif check_section.match?(/(?:all\s+)?(?:pass|✓|✅|complete|succeeded)/i)
            self_check = "passed"
          end
        end

        errors << "Missing files: #{missing.join(', ')}" if missing.any?
        errors << "Referenced commit hashes not found in git history" if !commits_exist && hashes.any?
        errors << "Self-check section indicates failure" if self_check == "failed"

        checks = {
          summary_exists: true,
          files_created: { checked: files_to_check.length, found: files_to_check.length - missing.length,
                           missing: missing },
          commits_exist: commits_exist,
          self_check: self_check
        }

        passed = missing.empty? && self_check != "failed"
        Output.json({ passed: passed, checks: checks, errors: errors }, raw: raw,
                                                                        raw_value: passed ? "passed" : "failed")
      end

      def self.verify_plan_structure(file_path, raw: false)
        Output.error("file path required") unless file_path

        cwd = Dir.pwd
        full_path = File.absolute_path?(file_path) ? file_path : File.join(cwd, file_path)

        unless File.exist?(full_path)
          Output.json({ error: "File not found", path: file_path }, raw: raw)
          return
        end

        content = File.read(full_path)
        fm = Frontmatter.extract(content)
        errors = []
        warnings = []

        required = %w[plan type depends_on files_modified autonomous must_haves]
        required.each do |field|
          errors << "Missing required frontmatter field: #{field}" unless fm.key?(field)
        end

        # Parse task elements
        tasks = []
        content.scan(%r{<task[^>]*>([\s\S]*?)</task>}) do
          task_content = ::Regexp.last_match(1)
          name_match = task_content.match(%r{<name>([\s\S]*?)</name>})
          task_name = name_match ? name_match[1].strip : "unnamed"
          has_files = task_content.include?("<files>")
          has_action = task_content.include?("<action>")
          has_verify = task_content.include?("<verify>")
          has_done = task_content.include?("<done>")

          errors << "Task missing <name> element" unless name_match
          errors << "Task '#{task_name}' missing <action>" unless has_action
          warnings << "Task '#{task_name}' missing <verify>" unless has_verify
          warnings << "Task '#{task_name}' missing <done>" unless has_done
          warnings << "Task '#{task_name}' missing <files>" unless has_files

          tasks << { name: task_name, hasFiles: has_files, hasAction: has_action, hasVerify: has_verify,
                     hasDone: has_done }
        end

        warnings << "No <task> elements found" if tasks.empty?

        Output.json({
                      valid: errors.empty?, errors: errors, warnings: warnings,
                      task_count: tasks.length, tasks: tasks,
                      frontmatter_fields: fm.keys
                    }, raw: raw, raw_value: errors.empty? ? "valid" : "invalid")
      end

      def self.verify_references(file_path, raw: false)
        Output.error("file path required") unless file_path

        cwd = Dir.pwd
        full_path = File.absolute_path?(file_path) ? file_path : File.join(cwd, file_path)

        unless File.exist?(full_path)
          Output.json({ error: "File not found", path: file_path }, raw: raw)
          return
        end

        content = File.read(full_path)
        found = []
        missing = []

        # @-references
        content.scan(%r{@([^\s,)]+/[^\s,)]+)}) do
          ref = ::Regexp.last_match(1)
          next if found.include?(ref) || missing.include?(ref)

          resolved = if ref.start_with?("~/")
                       File.join(Dir.home, ref[2..])
                     else
                       File.join(cwd, ref)
                     end
          File.exist?(resolved) ? found << ref : missing << ref
        end

        # Backtick file paths
        content.scan(%r{`([^`]+/[^`]+\.[a-zA-Z]{1,10})`}) do
          ref = ::Regexp.last_match(1)
          next if ref.start_with?("http") || ref.include?("${") || ref.include?("{{")
          next if found.include?(ref) || missing.include?(ref)

          resolved = File.join(cwd, ref)
          File.exist?(resolved) ? found << ref : missing << ref
        end

        Output.json({
                      valid: missing.empty?, found: found.length, missing: missing, total: found.length + missing.length
                    }, raw: raw, raw_value: missing.empty? ? "valid" : "invalid")
      end

      def self.verify_commits(argv, raw: false)
        Output.error("At least one commit hash required") if argv.empty?

        cwd = Dir.pwd
        valid = []
        invalid = []

        argv.each do |hash|
          result = exec_git(cwd, ["cat-file", "-t", hash])
          if result[:exit_code].zero? && result[:stdout].strip == "commit"
            valid << hash
          else
            invalid << hash
          end
        end

        Output.json({
                      all_valid: invalid.empty?, valid: valid, invalid: invalid, total: argv.length
                    }, raw: raw, raw_value: invalid.empty? ? "valid" : "invalid")
      end

      def self.verify_artifacts(plan_file_path, raw: false)
        Output.error("plan file path required") unless plan_file_path

        cwd = Dir.pwd
        full_path = File.absolute_path?(plan_file_path) ? plan_file_path : File.join(cwd, plan_file_path)

        unless File.exist?(full_path)
          Output.json({ error: "File not found", path: plan_file_path }, raw: raw)
          return
        end

        content = File.read(full_path)
        artifacts = parse_must_haves_block(content, "artifacts")

        if artifacts.empty?
          Output.json({ error: "No must_haves.artifacts found in frontmatter", path: plan_file_path }, raw: raw)
          return
        end

        results = []
        artifacts.each do |artifact|
          next if artifact.is_a?(String)
          next unless artifact.is_a?(Hash)

          art_path = artifact["path"]
          next unless art_path

          art_full_path = File.join(cwd, art_path)
          exists = File.exist?(art_full_path)
          check = { path: art_path, exists: exists, issues: [], passed: false }

          if exists
            file_content = safe_read_file(art_full_path) || ""
            line_count = file_content.split("\n").length

            if artifact["min_lines"] && line_count < artifact["min_lines"].to_i
              check[:issues] << "Only #{line_count} lines, need #{artifact['min_lines']}"
            end
            if artifact["contains"] && !file_content.include?(artifact["contains"])
              check[:issues] << "Missing pattern: #{artifact['contains']}"
            end
            if artifact["exports"]
              exports = artifact["exports"].is_a?(Array) ? artifact["exports"] : [artifact["exports"]]
              exports.each do |exp|
                check[:issues] << "Missing export: #{exp}" unless file_content.include?(exp)
              end
            end
            check[:passed] = check[:issues].empty?
          else
            check[:issues] << "File not found"
          end

          results << check
        end

        passed = results.count { |r| r[:passed] }
        Output.json({
                      all_passed: passed == results.length, passed: passed, total: results.length, artifacts: results
                    }, raw: raw, raw_value: passed == results.length ? "valid" : "invalid")
      end

      def self.verify_key_links(plan_file_path, raw: false)
        Output.error("plan file path required") unless plan_file_path

        cwd = Dir.pwd
        full_path = File.absolute_path?(plan_file_path) ? plan_file_path : File.join(cwd, plan_file_path)

        unless File.exist?(full_path)
          Output.json({ error: "File not found", path: plan_file_path }, raw: raw)
          return
        end

        content = File.read(full_path)
        key_links = parse_must_haves_block(content, "key_links")

        if key_links.empty?
          Output.json({ error: "No must_haves.key_links found in frontmatter", path: plan_file_path }, raw: raw)
          return
        end

        results = []
        key_links.each do |link|
          next if link.is_a?(String)
          next unless link.is_a?(Hash)

          check = { from: link["from"], to: link["to"], via: link["via"] || "", verified: false, detail: "" }
          source_content = safe_read_file(File.join(cwd, link["from"] || ""))

          if !source_content
            check[:detail] = "Source file not found"
          elsif link["pattern"]
            begin
              regex = Regexp.new(link["pattern"])
              if regex.match?(source_content)
                check[:verified] = true
                check[:detail] = "Pattern found in source"
              else
                target_content = safe_read_file(File.join(cwd, link["to"] || ""))
                if target_content && regex.match?(target_content)
                  check[:verified] = true
                  check[:detail] = "Pattern found in target"
                else
                  check[:detail] = "Pattern \"#{link['pattern']}\" not found in source or target"
                end
              end
            rescue RegexpError
              check[:detail] = "Invalid regex pattern: #{link['pattern']}"
            end
          elsif source_content.include?(link["to"] || "")
            check[:verified] = true
            check[:detail] = "Target referenced in source"
          else
            check[:detail] = "Target not referenced in source"
          end

          results << check
        end

        verified = results.count { |r| r[:verified] }
        Output.json({
                      all_verified: verified == results.length, verified: verified, total: results.length, links: results
                    }, raw: raw, raw_value: verified == results.length ? "valid" : "invalid")
      end

      def self.validate_consistency(raw: false)
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")
        errors = []
        warnings = []

        unless File.exist?(backlog_path)
          errors << "BACKLOG.md not found"
          Output.json({ passed: false, errors: errors, warnings: warnings }, raw: raw, raw_value: "failed")
          return
        end

        backlog_content = File.read(backlog_path)

        # Extract plans from BACKLOG — format: **NNN: Name**
        backlog_plans = []
        backlog_content.scan(/\*\*(\d{3}):\s+[^*]+\*\*/) { backlog_plans << ::Regexp.last_match(1) }

        # Get plans on disk
        disk_plans = []
        if File.directory?(plans_dir)
          Dir.children(plans_dir).each do |dir|
            next unless File.directory?(File.join(plans_dir, dir))

            dm = dir.match(/\A(\d{3})/)
            disk_plans << dm[1] if dm
          end
        end

        # Cross-check
        backlog_plans.each do |p|
          normalized = normalize_plan(p)
          unless disk_plans.include?(p) || disk_plans.include?(normalized)
            warnings << "Plan #{p} in BACKLOG.md but no directory on disk"
          end
        end

        disk_plans.each do |p|
          warnings << "Plan #{p} exists on disk but not in BACKLOG.md" unless backlog_plans.include?(p)
        end

        # Sequential numbering check
        plan_numbers = disk_plans.map(&:to_i).sort
        (1...plan_numbers.length).each do |i|
          gap_from = plan_numbers[i - 1].to_s.rjust(3, "0")
          gap_to = plan_numbers[i].to_s.rjust(3, "0")
          if plan_numbers[i] != plan_numbers[i - 1] + 1
            warnings << "Gap in plan numbering: #{gap_from} \u2192 #{gap_to}"
          end
        end

        # Plan directory checks
        if File.directory?(plans_dir)
          Dir.children(plans_dir).sort.each do |dir|
            dir_path = File.join(plans_dir, dir)
            next unless File.directory?(dir_path)

            plan_files = Dir.children(dir_path)
            warnings << "#{dir}: missing PLAN.md" unless plan_files.include?("PLAN.md")
          end
        end

        passed = errors.empty?
        Output.json({ passed: passed, errors: errors, warnings: warnings, warning_count: warnings.length },
                    raw: raw, raw_value: passed ? "passed" : "failed")
      end

      # --- Private helpers ---

      def self.find_plan_internal(cwd, plan)
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")
        normalized = normalize_plan(plan)

        return nil unless File.directory?(plans_dir)

        dirs = Dir.children(plans_dir).select { |d| File.directory?(File.join(plans_dir, d)) }.sort
        match = dirs.find { |d| d.start_with?(normalized) }
        return nil unless match

        dir_match = match.match(/\A(\d+)-?(.*)/)
        plan_number = dir_match ? dir_match[1] : normalized
        plan_name = dir_match && !dir_match[2].empty? ? dir_match[2] : nil

        { directory: File.join(PLANNING_DIR, "plans", match), plan_number: plan_number, plan_name: plan_name }
      rescue StandardError
        nil
      end

      def self.normalize_plan(plan)
        match = plan.to_s.match(/\A(\d+)/)
        return plan.to_s unless match

        match[1].rjust(3, "0")
      end

      def self.exec_git(cwd, args)
        cmd = "git #{args.map { |a| shell_escape(a) }.join(' ')}"
        stdout = `cd #{shell_escape(cwd)} && #{cmd} 2>&1`
        { exit_code: $CHILD_STATUS.exitstatus, stdout: stdout.strip, stderr: "" }
      rescue StandardError => e
        { exit_code: 1, stdout: "", stderr: e.message }
      end

      def self.shell_escape(str)
        return str if str.match?(%r{\A[a-zA-Z0-9._\-/=:@]+\z})

        "'#{str.gsub("'", "'\\''")}'"
      end

      def self.safe_read_file(path)
        File.read(path)
      rescue StandardError
        nil
      end

      def self.parse_must_haves_block(content, block_name)
        fm_match = content.match(/\A---\n([\s\S]+?)\n---/)
        return [] unless fm_match

        yaml = fm_match[1]
        block_pattern = /^\s{4}#{Regexp.escape(block_name)}:\s*$/m
        block_start = yaml.index(block_pattern)
        return [] unless block_start

        after_block = yaml[block_start..]
        lines = after_block.split("\n")[1..] # skip header line

        items = []
        current = nil

        lines.each do |line|
          next if line.strip.empty?

          indent = line[/\A(\s*)/, 1].length
          break if indent <= 4 && !line.strip.empty?

          if line.match?(/\A\s{6}-\s+/)
            items << current if current
            simple_match = line.match(/\A\s{6}-\s+"?([^"]+)"?\s*\z/)
            if simple_match && !line.include?(":")
              current = simple_match[1]
            else
              kv_match = line.match(/\A\s{6}-\s+(\w+):\s*"?([^"]*)"?\s*\z/)
              current = if kv_match
                          { kv_match[1] => kv_match[2] }
                        else
                          {}
                        end
            end
          elsif current.is_a?(Hash)
            kv_match = line.match(/\A\s{8,}(\w+):\s*"?([^"]*)"?\s*\z/)
            if kv_match
              val = kv_match[2]
              current[kv_match[1]] = val.match?(/\A\d+\z/) ? val.to_i : val
            end
            arr_match = line.match(/\A\s{10,}-\s+"?([^"]+)"?\s*\z/)
            if arr_match && current.any?
              last_key = current.keys.last
              current[last_key] = if current[last_key].is_a?(Array)
                                    current[last_key]
                                  else
                                    (current[last_key] ? [current[last_key]] : [])
                                  end
              current[last_key] << arr_match[1]
            end
          end
        end

        items << current if current
        items
      end

      private_class_method :find_plan_internal, :normalize_plan, :exec_git, :shell_escape,
                           :safe_read_file, :parse_must_haves_block
    end
  end
end
