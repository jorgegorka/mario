require "json"
require_relative "output"
require_relative "config_manager"
require_relative "frontmatter"

module Mario
  module Tools
    module StateManager
      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "load"
          load_state(raw: raw)
        when "get"
          get(argv.first, raw: raw)
        when "update"
          update(argv[0], argv[1], raw: raw)
        when "patch"
          patches = parse_patches(argv)
          patch(patches, raw: raw)
        when "add-decision"
          options = parse_named_args(argv, %w[summary rationale])
          add_decision(options, raw: raw)
        when "add-blocker"
          text = extract_flag(argv, "--text") || argv.first
          add_blocker(text, raw: raw)
        when "resolve-blocker"
          text = extract_flag(argv, "--text") || argv.first
          resolve_blocker(text, raw: raw)
        when "record-session"
          options = parse_named_args(argv, %w[stopped-at resume-file])
          record_session(options, raw: raw)
        else
          Output.error("Unknown state subcommand: #{subcommand}")
        end
      end

      def self.history_digest(_argv, raw: false)
        cwd = Dir.pwd
        plans_dir = File.join(cwd, ".planning", "plans")
        digest = { plans: {}, decisions: [], tech_stack: [] }

        unless File.directory?(plans_dir)
          Output.json(digest, raw: raw)
          return
        end

        tech_stack_set = []
        Dir.children(plans_dir).sort.each do |dir|
          dir_path = File.join(plans_dir, dir)
          next unless File.directory?(dir_path)

          summary_path = File.join(dir_path, "SUMMARY.md")
          next unless File.exist?(summary_path)

          content = File.read(summary_path)
          fm = Frontmatter.extract(content)

          plan_num = dir.split("-").first
          plan_name = dir.split("-")[1..].join(" ") || "Unknown"
          digest[:plans][plan_num] ||= { name: plan_name, provides: [], affects: [], patterns: [] }

          dep_graph = fm["dependency-graph"] || {}
          (dep_graph["provides"] || fm["provides"] || []).each { |p| digest[:plans][plan_num][:provides] << p }
          (dep_graph["affects"] || []).each { |a| digest[:plans][plan_num][:affects] << a }
          (fm["patterns-established"] || []).each { |p| digest[:plans][plan_num][:patterns] << p }
          (fm["key-decisions"] || []).each { |d| digest[:decisions] << { plan: plan_num, decision: d } }

          tech = fm["tech-stack"]
          (tech["added"] || []).each { |t| tech_stack_set << (t.is_a?(String) ? t : t["name"]) } if tech.is_a?(Hash)
        rescue StandardError
          next
        end

        digest[:plans].each_value do |p|
          p[:provides].uniq!
          p[:affects].uniq!
          p[:patterns].uniq!
        end
        digest[:tech_stack] = tech_stack_set.uniq

        Output.json(digest, raw: raw)
      end

      def self.summary_extract(argv, raw: false)
        path = argv.shift
        Output.error("path required") unless path
        fields_idx = argv.index("--fields")
        fields = fields_idx ? argv[fields_idx + 1]&.split(",") : nil

        cwd = Dir.pwd
        full_path = File.expand_path(path, cwd)
        content = File.read(full_path)
        fm = Frontmatter.extract(content)

        result = fields ? fm.slice(*fields) : fm
        Output.json(result, raw: raw)
      rescue Errno::ENOENT
        Output.error("File not found: #{path}")
      end

      def self.snapshot(_argv, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        Output.error("STATE.md not found") unless File.exist?(state_path)

        content = File.read(state_path)
        fields = {}
        content.scan(/\*\*(.+?):\*\*\s*(.+)/) { |k, v| fields[k.strip] = v.strip }

        Output.json(fields, raw: raw)
      end

      # --- Core state operations ---

      def self.load_state(raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)
        planning_dir = File.join(cwd, ".planning")

        state_raw = begin
          File.read(File.join(planning_dir, "STATE.md"))
        rescue Errno::ENOENT
          ""
        end

        result = {
          config: config,
          state_raw: state_raw,
          state_exists: !state_raw.empty?,
          backlog_exists: File.exist?(File.join(planning_dir, "BACKLOG.md")),
          config_exists: File.exist?(File.join(planning_dir, "config.json"))
        }

        if raw
          lines = config.map { |k, v| "#{k}=#{v}" }
          lines << "config_exists=#{result[:config_exists]}"
          lines << "backlog_exists=#{result[:backlog_exists]}"
          lines << "state_exists=#{result[:state_exists]}"
          $stdout.write(lines.join("\n"))
          exit 0
        end

        Output.json(result)
      end

      def self.get(section, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        content = File.read(state_path)

        unless section
          Output.json({ content: content }, raw: raw, raw_value: content)
          return
        end

        escaped = Regexp.escape(section)

        # Check for **field:** value
        if (match = content.match(/\*\*#{escaped}:\*\*\s*(.*)/i))
          Output.json({ section => match[1].strip }, raw: raw, raw_value: match[1].strip)
          return
        end

        # Check for ## Section
        if (match = content.match(/##\s*#{escaped}\s*\n([\s\S]*?)(?=\n##|$)/i))
          Output.json({ section => match[1].strip }, raw: raw, raw_value: match[1].strip)
          return
        end

        Output.json({ error: "Section or field \"#{section}\" not found" }, raw: raw, raw_value: "")
      rescue Errno::ENOENT
        Output.error("STATE.md not found")
      end

      def self.update(field, value, raw: false)
        Output.error("field and value required for state update") unless field && value

        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        content = File.read(state_path)

        new_content = replace_field(content, field, value)
        if new_content
          File.write(state_path, new_content)
          Output.json({ updated: true })
        else
          Output.json({ updated: false, reason: "Field \"#{field}\" not found in STATE.md" })
        end
      rescue Errno::ENOENT
        Output.json({ updated: false, reason: "STATE.md not found" })
      end

      def self.patch(patches, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        content = File.read(state_path)

        results = { updated: [], failed: [] }
        patches.each do |field, value|
          new_content = replace_field(content, field, value)
          if new_content
            content = new_content
            results[:updated] << field
          else
            results[:failed] << field
          end
        end

        File.write(state_path, content) unless results[:updated].empty?
        Output.json(results, raw: raw, raw_value: results[:updated].empty? ? "false" : "true")
      rescue Errno::ENOENT
        Output.error("STATE.md not found")
      end

      def self.add_decision(options, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        unless File.exist?(state_path)
          Output.json({ error: "STATE.md not found" }, raw: raw)
          return
        end

        summary = options["summary"]
        Output.error("summary required") unless summary

        rationale = options["rationale"]
        entry = "- #{summary}#{" — #{rationale}" if rationale}"

        content = File.read(state_path)
        pattern = /(###?\s*(?:Decisions|Decisions Made|Accumulated.*Decisions)\s*\n)([\s\S]*?)(?=\n###?|\n##[^#]|\z)/i

        if (match = content.match(pattern))
          body = match[2].gsub(/None yet\.?\s*\n?/i, "").gsub(/No decisions yet\.?\s*\n?/i, "")
          body = "#{body.rstrip}\n#{entry}\n"
          content = content.sub(pattern, "#{match[1]}#{body}")
          File.write(state_path, content)
          Output.json({ added: true, decision: entry }, raw: raw, raw_value: "true")
        else
          Output.json({ added: false, reason: "Decisions section not found" }, raw: raw, raw_value: "false")
        end
      end

      def self.add_blocker(text, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        unless File.exist?(state_path)
          Output.json({ error: "STATE.md not found" }, raw: raw)
          return
        end
        Output.error("text required") unless text

        content = File.read(state_path)
        entry = "- #{text}"
        pattern = %r{(###?\s*(?:Blockers|Blockers/Concerns|Concerns)\s*\n)([\s\S]*?)(?=\n###?|\n##[^#]|\z)}i

        if (match = content.match(pattern))
          body = match[2].gsub(/None\.?\s*\n?/i, "").gsub(/None yet\.?\s*\n?/i, "")
          body = "#{body.rstrip}\n#{entry}\n"
          content = content.sub(pattern, "#{match[1]}#{body}")
          File.write(state_path, content)
          Output.json({ added: true, blocker: text }, raw: raw, raw_value: "true")
        else
          Output.json({ added: false, reason: "Blockers section not found" }, raw: raw, raw_value: "false")
        end
      end

      def self.resolve_blocker(text, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        unless File.exist?(state_path)
          Output.json({ error: "STATE.md not found" }, raw: raw)
          return
        end
        Output.error("text required") unless text

        content = File.read(state_path)
        pattern = %r{(###?\s*(?:Blockers|Blockers/Concerns|Concerns)\s*\n)([\s\S]*?)(?=\n###?|\n##[^#]|\z)}i

        if (match = content.match(pattern))
          lines = match[2].split("\n")
          filtered = lines.reject { |line| line.start_with?("- ") && line.downcase.include?(text.downcase) }
          new_body = filtered.join("\n")
          new_body = "None\n" if new_body.strip.empty? || !new_body.include?("- ")
          content = content.sub(pattern, "#{match[1]}#{new_body}")
          File.write(state_path, content)
          Output.json({ resolved: true, blocker: text }, raw: raw, raw_value: "true")
        else
          Output.json({ resolved: false, reason: "Blockers section not found" }, raw: raw, raw_value: "false")
        end
      end

      def self.record_session(options, raw: false)
        cwd = Dir.pwd
        state_path = File.join(cwd, ".planning", "STATE.md")
        unless File.exist?(state_path)
          Output.json({ error: "STATE.md not found" }, raw: raw)
          return
        end

        content = File.read(state_path)
        now = Time.now.utc.iso8601
        updated = []

        new_content = replace_field(content, "Last session", now)
        if new_content
          content = new_content
          updated << "Last session"
        end

        if options["stopped-at"]
          %w[Stopped At Stopped at].each do |field|
            new_content = replace_field(content, field, options["stopped-at"])
            next unless new_content

            content = new_content
            updated << "Stopped At"
            break
          end
        end

        resume = options["resume-file"] || "None"
        ["Resume File", "Resume file"].each do |field|
          new_content = replace_field(content, field, resume)
          next unless new_content

          content = new_content
          updated << "Resume File"
          break
        end

        if updated.any?
          File.write(state_path, content)
          Output.json({ recorded: true, updated: updated }, raw: raw, raw_value: "true")
        else
          Output.json({ recorded: false, reason: "No session fields found" }, raw: raw, raw_value: "false")
        end
      end

      # --- Private helpers ---

      def self.extract_field(content, field_name)
        pattern = /\*\*#{Regexp.escape(field_name)}:\*\*\s*(.+)/i
        match = content.match(pattern)
        match ? match[1].strip : nil
      end

      def self.replace_field(content, field_name, new_value)
        escaped = Regexp.escape(field_name)
        pattern = /(\*\*#{escaped}:\*\*\s*)(.*)/i
        return nil unless content.match?(pattern)

        content.sub(pattern, "\\1#{new_value}")
      end

      def self.extract_flag(argv, flag)
        idx = argv.index(flag)
        return nil unless idx

        argv[idx + 1]
      end

      def self.parse_patches(argv)
        patches = {}
        i = 0
        while i < argv.length
          if argv[i].start_with?("--")
            key = argv[i].sub(/\A--/, "")
            patches[key] = argv[i + 1]
            i += 2
          else
            i += 1
          end
        end
        patches
      end

      def self.parse_named_args(argv, known_keys)
        result = {}
        known_keys.each do |key|
          flag = "--#{key}"
          idx = argv.index(flag)
          result[key] = argv[idx + 1] if idx
        end
        result
      end

      private_class_method :extract_field, :replace_field, :extract_flag, :parse_patches, :parse_named_args
    end
  end
end
