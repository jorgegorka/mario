require "json"
require "fileutils"
require_relative "output"

module MarketingMario
  module Tools
    module PlanManager
      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "add"
          add(argv.join(" "), raw: raw)
        when "remove"
          force = argv.delete("--force")
          remove(argv.first, force: !!force, raw: raw)
        when "complete"
          complete(argv.first, raw: raw)
        else
          Output.error("Unknown plan subcommand. Available: add, remove, complete")
        end
      end

      def self.find(argv, raw: false)
        plan = argv.first
        Output.error("plan identifier required") unless plan

        cwd = Dir.pwd
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")
        normalized = normalize_plan_number(plan)
        not_found = { found: false, directory: nil, plan_number: nil, plan_name: nil }

        unless File.directory?(plans_dir)
          Output.json(not_found, raw: raw, raw_value: "")
          return
        end

        dirs = Dir.children(plans_dir).select { |d| File.directory?(File.join(plans_dir, d)) }.sort
        match = dirs.find { |d| d.start_with?("#{normalized}-") || d == normalized }

        unless match
          Output.json(not_found, raw: raw, raw_value: "")
          return
        end

        dir_match = match.match(/\A(\d+)-?(.*)/)
        plan_number = dir_match ? dir_match[1] : normalized
        plan_name = dir_match && !dir_match[2].empty? ? dir_match[2] : nil

        result = {
          found: true,
          directory: File.join(PLANNING_DIR, "plans", match),
          plan_number: plan_number,
          plan_name: plan_name
        }
        Output.json(result, raw: raw, raw_value: result[:directory])
      rescue StandardError
        Output.json(not_found, raw: raw, raw_value: "")
      end

      def self.list(options, raw: false)
        cwd = Dir.pwd
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")

        unless File.directory?(plans_dir)
          Output.json({ directories: [], count: 0 }, raw: raw, raw_value: "")
          return
        end

        dirs = Dir.children(plans_dir)
                  .select { |d| File.directory?(File.join(plans_dir, d)) }
                  .sort_by { |d| d.match(/\A(\d+)/)&.[](1).to_i }

        if options[:type]
          files = []
          dirs.each do |dir|
            dir_files = Dir.children(File.join(plans_dir, dir))
            filtered = case options[:type]
                       when "plans" then dir_files.select { |f| f.end_with?("-PLAN.md") || f == "PLAN.md" }
                       when "summaries" then dir_files.select { |f| f.end_with?("-SUMMARY.md") || f == "SUMMARY.md" }
                       else dir_files
                       end
            files.concat(filtered.sort)
          end
          Output.json({ files: files, count: files.size }, raw: raw, raw_value: files.join("\n"))
        else
          Output.json({ directories: dirs, count: dirs.size }, raw: raw, raw_value: dirs.join("\n"))
        end
      end

      def self.add(description, raw: false)
        Output.error("description required") unless description && !description.empty?
        cwd = Dir.pwd
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")

        existing = if File.directory?(plans_dir)
                     Dir.children(plans_dir)
                        .select { |d| File.directory?(File.join(plans_dir, d)) }
                        .filter_map do |d|
                          d.match(/\A(\d+)/)
                          ::Regexp.last_match(1)&.to_i
                     end
                        .max || 0
                   else
                     0
                   end

        new_num = format("%03d", existing + 1)
        slug = description.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
        dir_name = "#{new_num}-#{slug}"
        FileUtils.mkdir_p(File.join(plans_dir, dir_name))

        Output.json({ added: true, plan: new_num, directory: dir_name }, raw: raw, raw_value: new_num)
      end

      def self.remove(plan, force: false, raw: false)
        Output.error("plan required") unless plan
        cwd = Dir.pwd
        plans_dir = File.join(cwd, PLANNING_DIR, "plans")
        normalized = normalize_plan_number(plan)

        unless File.directory?(plans_dir)
          Output.json({ removed: false, reason: "plans directory not found" }, raw: raw, raw_value: "false")
          return
        end

        dirs = Dir.children(plans_dir).select { |d| File.directory?(File.join(plans_dir, d)) }.sort
        match = dirs.find { |d| d.start_with?("#{normalized}-") || d == normalized }

        unless match
          Output.json({ removed: false, reason: "plan not found" }, raw: raw, raw_value: "false")
          return
        end

        dir_path = File.join(plans_dir, match)
        has_content = Dir.children(dir_path).any? { |f| f.end_with?(".md") }

        if has_content && !force
          Output.json({ removed: false, reason: "plan has content, use --force" }, raw: raw, raw_value: "false")
          return
        end

        FileUtils.rm_rf(dir_path)
        Output.json({ removed: true, plan: normalized, directory: match }, raw: raw, raw_value: "true")
      end

      def self.complete(plan, raw: false)
        Output.error("plan required") unless plan
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")
        normalized = normalize_plan_number(plan)

        if File.exist?(backlog_path)
          content = File.read(backlog_path)
          escaped = Regexp.escape(normalized)
          content = content.sub(/-\s*\[ \]\s*\*\*#{escaped}:/, "- [x] **#{normalized}:")
          File.write(backlog_path, content)
        end

        Output.json({ completed: true, plan: normalized }, raw: raw, raw_value: "true")
      end

      def self.normalize_plan_number(plan)
        match = plan.to_s.match(/\A(\d+)/)
        return plan.to_s unless match

        match[1].rjust(3, "0")
      end

      private_class_method :normalize_plan_number
    end
  end
end
