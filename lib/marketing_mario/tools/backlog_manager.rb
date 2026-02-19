require "json"
require_relative "output"

module MarketingMario
  module Tools
    module BacklogManager
      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "analyze"
          analyze(raw: raw)
        when "add"
          add(argv.join(" "), raw: raw)
        when "complete"
          complete(argv.shift, argv, raw: raw)
        when "get"
          get(argv.first, raw: raw)
        else
          Output.error("Unknown backlog subcommand. Available: analyze, add, complete, get")
        end
      end

      def self.progress(argv, raw: false)
        format = argv.first || "json"
        render_progress(format, raw: raw)
      end

      def self.analyze(raw: false)
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")

        unless File.exist?(backlog_path)
          Output.json({ error: "BACKLOG.md not found", plans: [], current_plan: nil }, raw: raw)
          return
        end

        content = File.read(backlog_path)
        plans = parse_plans(content)

        completed = plans.count { |p| p[:done] }
        total = plans.size
        current = plans.find { |p| !p[:done] }
        next_plan = current ? plans.find { |p| !p[:done] && p[:number] != current[:number] } : nil

        result = {
          plans: plans,
          plan_count: total,
          completed_plans: completed,
          progress_percent: total.positive? ? (completed.to_f / total * 100).round : 0,
          current_plan: current ? current[:number] : nil,
          next_plan: next_plan ? next_plan[:number] : nil,
          project_name: extract_project_name(content)
        }

        Output.json(result, raw: raw)
      end

      def self.add(description, raw: false)
        Output.error("description required") unless description && !description.empty?
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")

        unless File.exist?(backlog_path)
          Output.json({ added: false, reason: "BACKLOG.md not found" }, raw: raw, raw_value: "false")
          return
        end

        content = File.read(backlog_path)
        plans = parse_plans(content)
        max_num = plans.map { |p| p[:number].to_i }.max || 0
        new_num = format("%03d", max_num + 1)

        entry = "- [ ] **#{new_num}: #{description}**"
        content = insert_plan_entry(content, entry)
        File.write(backlog_path, content)

        Output.json({ added: true, plan: new_num, description: description }, raw: raw, raw_value: new_num)
      end

      def self.complete(plan_num, options, raw: false)
        Output.error("plan number required") unless plan_num
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")

        unless File.exist?(backlog_path)
          Output.json({ completed: false, reason: "BACKLOG.md not found" }, raw: raw, raw_value: "false")
          return
        end

        normalized = normalize_plan_number(plan_num)
        commit_idx = options.index("--commit")
        commit = commit_idx ? options[commit_idx + 1] : nil

        content = File.read(backlog_path)
        escaped = Regexp.escape(normalized)

        # Check off the plan in the Plans section
        content = content.sub(/-\s*\[ \]\s*\*\*#{escaped}:([^\n]*)/, "- [x] **#{normalized}:\\1")

        # Extract plan name for completed table
        name_match = content.match(/-\s*\[x\]\s*\*\*#{escaped}:\s*([^*]+)\*\*/)
        plan_name = name_match ? name_match[1].strip : "Plan #{normalized}"
        # Strip leading description separator if present
        plan_name = plan_name.sub(/\A\s*—\s*/, "").strip if plan_name.include?("—")

        # Add to Completed table
        date = Time.now.utc.strftime("%Y-%m-%d")
        commit_str = commit || ""
        table_row = "| #{normalized} | #{plan_name} | #{date} | #{commit_str} |"
        content = append_completed_row(content, table_row)

        File.write(backlog_path, content)
        Output.json({ completed: true, plan: normalized, date: date, commit: commit_str }, raw: raw, raw_value: "true")
      end

      def self.get(plan_num, raw: false)
        Output.error("plan number required") unless plan_num
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")

        unless File.exist?(backlog_path)
          Output.json({ found: false, error: "BACKLOG.md not found" }, raw: raw, raw_value: "")
          return
        end

        normalized = normalize_plan_number(plan_num)
        content = File.read(backlog_path)
        plans = parse_plans(content)
        plan = plans.find { |p| p[:number] == normalized }

        unless plan
          Output.json({ found: false, plan_number: normalized }, raw: raw, raw_value: "")
          return
        end

        Output.json({ found: true }.merge(plan), raw: raw, raw_value: plan[:name])
      end

      def self.render_progress(format, raw: false)
        cwd = Dir.pwd
        backlog_path = File.join(cwd, PLANNING_DIR, "BACKLOG.md")
        project_name = "Project"

        plans = []
        if File.exist?(backlog_path)
          content = File.read(backlog_path)
          plans = parse_plans(content)
          project_name = extract_project_name(content)
        end

        completed = plans.count { |p| p[:done] }
        total = plans.size
        percent = total.positive? ? (completed.to_f / total * 100).round : 0

        case format
        when "table"
          bar_width = 10
          filled = (percent.to_f / 100 * bar_width).round
          bar = ("\u2588" * filled) + ("\u2591" * (bar_width - filled))
          out = "# #{project_name}\n\n"
          out += "**Progress:** [#{bar}] #{completed}/#{total} plans (#{percent}%)\n\n"
          out += "| # | Plan | Status |\n"
          out += "|---|------|--------|\n"
          plans.each do |p|
            status = p[:done] ? "Complete" : "Pending"
            out += "| #{p[:number]} | #{p[:name]} | #{status} |\n"
          end
          Output.json({ rendered: out }, raw: raw, raw_value: out)
        when "bar"
          bar_width = 20
          filled = (percent.to_f / 100 * bar_width).round
          bar = ("\u2588" * filled) + ("\u2591" * (bar_width - filled))
          text = "[#{bar}] #{completed}/#{total} plans (#{percent}%)"
          Output.json({ bar: text, percent: percent, completed: completed, total: total }, raw: raw, raw_value: text)
        else
          Output.json({
                        project_name: project_name, plans: plans,
                        total_plans: total, completed_plans: completed, percent: percent
                      }, raw: raw)
        end
      end

      def self.parse_plans(content)
        plans = []
        content.scan(/-\s*\[(x| )\]\s*\*\*(\d{3}):\s*([^*]+)\*\*(?:\s*—\s*(.+))?/) do |done, number, name, description|
          plans << {
            number: number,
            name: name.strip,
            description: description&.strip,
            done: done == "x"
          }
        end
        plans.sort_by { |p| p[:number].to_i }
      end

      def self.extract_project_name(content)
        match = content.match(/^#\s+Backlog:\s*(.+)/i)
        match ? match[1].strip : "Project"
      end

      def self.insert_plan_entry(content, entry)
        # Insert before the Upcoming section if it exists, otherwise append to Plans section
        if content.match?(/^##\s+Upcoming/i)
          content.sub(/^(##\s+Upcoming)/i, "#{entry}\n\n\\1")
        elsif content.match?(/^##\s+Completed/i)
          content.sub(/^(##\s+Completed)/i, "#{entry}\n\n\\1")
        else
          content.rstrip + "\n#{entry}\n"
        end
      end

      def self.append_completed_row(content, row)
        # Find the Completed table and append the row
        if content.match?(/^\|\s*#\s*\|\s*Plan\s*\|/)
          lines = content.lines
          last_table_idx = lines.rindex { |l| l.start_with?("|") }
          lines.insert(last_table_idx + 1, "#{row}\n") if last_table_idx
          lines.join
        elsif content.match?(/^##\s+Completed/i)
          # Table header doesn't exist yet, create it
          table = "\n| # | Plan | Completed | Commit |\n|---|------|-----------|--------|\n#{row}\n"
          content.sub(/(^##\s+Completed[^\n]*\n)/i, "\\1#{table}")
        else
          # No Completed section, append one
          content.rstrip + "\n\n## Completed\n\n| # | Plan | Completed | Commit |\n|---|------|-----------|--------|\n#{row}\n"
        end
      end

      def self.normalize_plan_number(plan)
        match = plan.to_s.match(/\A(\d+)/)
        return plan.to_s unless match

        match[1].rjust(3, "0")
      end

      private_class_method :parse_plans, :extract_project_name, :insert_plan_entry,
                           :append_completed_row, :render_progress, :normalize_plan_number
    end
  end
end
