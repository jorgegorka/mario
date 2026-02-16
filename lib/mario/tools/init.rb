require "json"
require "fileutils"
require_relative "output"
require_relative "config_manager"
require_relative "model_profiles"
require_relative "frontmatter"

module Mario
  module Tools
    module Init
      def self.dispatch(argv, raw: false)
        workflow = argv.shift
        includes = parse_include_flag(argv)

        case workflow
        when "execute"
          execute(argv.first, includes, raw: raw)
        when "plan"
          plan(argv.first, includes, raw: raw)
        when "new-project"
          new_project(raw: raw)
        when "quick"
          quick(argv.join(" "), raw: raw)
        when "todos"
          todos(argv.first, raw: raw)
        when "progress"
          init_progress(includes, raw: raw)
        when "template"
          template(argv, raw: raw)
        else
          Output.error("Unknown init workflow: #{workflow}\nAvailable: execute, plan, new-project, quick, todos, progress, template")
        end
      end

      def self.execute(plan_num, includes, raw: false)
        Output.error("plan required for init execute") unless plan_num

        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)
        plan_info = find_plan_internal(cwd, plan_num)

        result = {
          executor_model: resolve_model(cwd, "mario-executor"),
          commit_docs: config["commit_docs"],
          plan_found: !plan_info.nil?,
          plan_dir: plan_info&.dig(:directory),
          plan_number: plan_info&.dig(:plan_number),
          plan_name: plan_info&.dig(:plan_name),
          plan_slug: plan_info&.dig(:plan_slug),
          plans: plan_info&.dig(:plans) || [],
          summaries: plan_info&.dig(:summaries) || [],
          incomplete_plans: plan_info&.dig(:incomplete_plans) || [],
          plan_count: plan_info&.dig(:plans)&.length || 0,
          incomplete_count: plan_info&.dig(:incomplete_plans)&.length || 0,
          state_exists: path_exists?(cwd, ".planning/STATE.md"),
          backlog_exists: path_exists?(cwd, ".planning/BACKLOG.md"),
          config_exists: path_exists?(cwd, ".planning/config.json")
        }

        result[:state_content] = safe_read_file(File.join(cwd, ".planning", "STATE.md")) if includes.include?("state")
        if includes.include?("config")
          result[:config_content] =
            safe_read_file(File.join(cwd, ".planning", "config.json"))
        end
        if includes.include?("backlog")
          result[:backlog_content] =
            safe_read_file(File.join(cwd, ".planning", "BACKLOG.md"))
        end

        Output.json(result, raw: raw)
      end

      def self.plan(plan_num, includes, raw: false)
        Output.error("plan required for init plan") unless plan_num

        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)
        plan_info = find_plan_internal(cwd, plan_num)

        result = {
          researcher_model: resolve_model(cwd, "mario-phase-researcher"),
          planner_model: resolve_model(cwd, "mario-planner"),
          research_enabled: config["research"],
          commit_docs: config["commit_docs"],
          plan_found: !plan_info.nil?,
          plan_dir: plan_info&.dig(:directory),
          plan_number: plan_info&.dig(:plan_number),
          plan_name: plan_info&.dig(:plan_name),
          plan_slug: plan_info&.dig(:plan_slug),
          has_research: plan_info&.dig(:has_research) || false,
          has_plans: (plan_info&.dig(:plans)&.length || 0).positive?,
          plan_count: plan_info&.dig(:plans)&.length || 0,
          planning_exists: path_exists?(cwd, ".planning"),
          backlog_exists: path_exists?(cwd, ".planning/BACKLOG.md")
        }

        result[:state_content] = safe_read_file(File.join(cwd, ".planning", "STATE.md")) if includes.include?("state")
        if includes.include?("backlog")
          result[:backlog_content] =
            safe_read_file(File.join(cwd, ".planning", "BACKLOG.md"))
        end
        if includes.include?("requirements")
          result[:requirements_content] =
            safe_read_file(File.join(cwd, ".planning", "REQUIREMENTS.md"))
        end

        if includes.include?("research") && plan_info&.dig(:directory)
          plan_dir_full = File.join(cwd, plan_info[:directory])
          research_file = begin
            Dir.children(plan_dir_full).find do |f|
              f.end_with?("-RESEARCH.md") || f == "RESEARCH.md"
            end
          rescue StandardError
            nil
          end
          result[:research_content] = safe_read_file(File.join(plan_dir_full, research_file)) if research_file
        end

        Output.json(result, raw: raw)
      end

      def self.new_project(raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)

        # Detect existing code
        has_code = false
        begin
          files = `find #{cwd} -maxdepth 3 \\( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.swift" -o -name "*.java" -o -name "*.rb" \\) 2>/dev/null | grep -v node_modules | grep -v .git | head -5`
          has_code = !files.strip.empty?
        rescue StandardError
          # ignore
        end

        has_package_file = %w[package.json requirements.txt Cargo.toml go.mod Package.swift Gemfile].any? do |f|
          File.exist?(File.join(cwd, f))
        end

        result = {
          researcher_model: resolve_model(cwd, "mario-project-researcher"),
          synthesizer_model: resolve_model(cwd, "mario-research-synthesizer"),
          backlog_planner_model: resolve_model(cwd, "mario-backlog-planner"),
          commit_docs: config["commit_docs"],
          project_exists: path_exists?(cwd, ".planning/PROJECT.md"),
          has_codebase_map: path_exists?(cwd, ".planning/codebase"),
          planning_exists: path_exists?(cwd, ".planning"),
          has_existing_code: has_code,
          has_package_file: has_package_file,
          is_brownfield: has_code || has_package_file,
          needs_codebase_map: (has_code || has_package_file) && !path_exists?(cwd, ".planning/codebase"),
          has_git: path_exists?(cwd, ".git")
        }

        Output.json(result, raw: raw)
      end

      def self.quick(description, raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)
        now = Time.now.utc
        slug = description && !description.empty? ? generate_slug(description)&.slice(0, 40) : nil

        plans_dir = File.join(cwd, ".planning", "plans")
        next_num = 1
        if File.directory?(plans_dir)
          existing = Dir.children(plans_dir)
                        .select { |d| File.directory?(File.join(plans_dir, d)) }
                        .filter_map do |d|
                          m = d.match(/\A(\d+)/)
                          m ? m[1].to_i : nil
          end
          next_num = existing.max + 1 if existing.any?
        end

        padded = format("%03d", next_num)

        result = {
          planner_model: resolve_model(cwd, "mario-planner"),
          executor_model: resolve_model(cwd, "mario-executor"),
          commit_docs: config["commit_docs"],
          next_num: next_num,
          padded_num: padded,
          slug: slug,
          description: description && !description.empty? ? description : nil,
          date: now.strftime("%Y-%m-%d"),
          timestamp: now.iso8601,
          plans_dir: ".planning/plans",
          task_dir: slug ? ".planning/plans/#{padded}-#{slug}" : nil,
          backlog_exists: path_exists?(cwd, ".planning/BACKLOG.md"),
          planning_exists: path_exists?(cwd, ".planning")
        }

        Output.json(result, raw: raw)
      end

      def self.todos(area, raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)
        now = Time.now.utc

        pending_dir = File.join(cwd, ".planning", "todos", "pending")
        count = 0
        todo_list = []

        if File.directory?(pending_dir)
          Dir[File.join(pending_dir, "*.md")].each do |file|
            content = File.read(file)
            created = content[/^created:\s*(.+)$/i, 1]&.strip || "unknown"
            title = content[/^title:\s*(.+)$/i, 1]&.strip || "Untitled"
            todo_area = content[/^area:\s*(.+)$/i, 1]&.strip || "general"

            next if area && todo_area != area

            count += 1
            todo_list << {
              file: File.basename(file), created: created, title: title, area: todo_area,
              path: File.join(".planning", "todos", "pending", File.basename(file))
            }
          end
        end

        result = {
          commit_docs: config["commit_docs"],
          date: now.strftime("%Y-%m-%d"),
          timestamp: now.iso8601,
          todo_count: count,
          todos: todo_list,
          area_filter: area,
          pending_dir: ".planning/todos/pending",
          completed_dir: ".planning/todos/completed",
          planning_exists: path_exists?(cwd, ".planning"),
          todos_dir_exists: path_exists?(cwd, ".planning/todos"),
          pending_dir_exists: path_exists?(cwd, ".planning/todos/pending")
        }

        Output.json(result, raw: raw)
      end

      def self.template(argv, raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)

        require_relative "template_manager"
        TemplateManager.list(raw: false)

        plans_dir = File.join(cwd, ".planning", "plans")
        next_num = 1
        if File.directory?(plans_dir)
          existing = Dir.children(plans_dir)
                        .select { |d| File.directory?(File.join(plans_dir, d)) }
                        .filter_map do |d|
                          m = d.match(/\A(\d+)/)
                          m ? m[1].to_i : nil
          end
          next_num = existing.max + 1 if existing.any?
        end

        padded = format("%03d", next_num)
        template_name = argv.first

        result = {
          planner_model: resolve_model(cwd, "mario-planner"),
          executor_model: resolve_model(cwd, "mario-executor"),
          commit_docs: config["commit_docs"],
          template_name: template_name,
          next_num: next_num,
          padded_num: padded,
          plans_dir: ".planning/plans",
          backlog_exists: path_exists?(cwd, ".planning/BACKLOG.md"),
          planning_exists: path_exists?(cwd, ".planning")
        }

        Output.json(result, raw: raw)
      end

      def self.init_progress(includes, raw: false)
        cwd = Dir.pwd
        config = ConfigManager.load_config(cwd)

        plans_dir = File.join(cwd, ".planning", "plans")
        plans = []
        current_plan = nil
        next_plan = nil

        if File.directory?(plans_dir)
          dirs = Dir.children(plans_dir)
                    .select { |d| File.directory?(File.join(plans_dir, d)) }
                    .sort

          dirs.each do |dir|
            m = dir.match(/\A(\d+)-?(.*)/)
            plan_number = m ? m[1] : dir
            plan_name = m && !m[2].empty? ? m[2] : nil

            plan_path = File.join(plans_dir, dir)
            plan_files = Dir.children(plan_path)

            plan_docs = plan_files.select { |f| f.end_with?("-PLAN.md") || f == "PLAN.md" }
            summaries = plan_files.select { |f| f.end_with?("-SUMMARY.md") || f == "SUMMARY.md" }
            has_research = plan_files.any? { |f| f.end_with?("-RESEARCH.md") || f == "RESEARCH.md" }

            status = if summaries.length >= plan_docs.length && plan_docs.any?
                       "complete"
                     elsif plan_docs.any?
                       "in_progress"
                     elsif has_research
                       "researched"
                     else
                       "pending"
                     end

            plan_entry = {
              number: plan_number, name: plan_name,
              directory: File.join(".planning", "plans", dir),
              status: status, plan_count: plan_docs.length,
              summary_count: summaries.length, has_research: has_research
            }

            plans << plan_entry
            current_plan ||= plan_entry if %w[in_progress researched].include?(status)
            next_plan ||= plan_entry if status == "pending"
          end
        end

        result = {
          executor_model: resolve_model(cwd, "mario-executor"),
          planner_model: resolve_model(cwd, "mario-planner"),
          commit_docs: config["commit_docs"],
          plans: plans,
          plan_count: plans.length,
          completed_count: plans.count { |p| p[:status] == "complete" },
          in_progress_count: plans.count { |p| p[:status] == "in_progress" },
          current_plan: current_plan,
          next_plan: next_plan,
          has_work_in_progress: !current_plan.nil?,
          project_exists: path_exists?(cwd, ".planning/PROJECT.md"),
          backlog_exists: path_exists?(cwd, ".planning/BACKLOG.md"),
          state_exists: path_exists?(cwd, ".planning/STATE.md")
        }

        result[:state_content] = safe_read_file(File.join(cwd, ".planning", "STATE.md")) if includes.include?("state")
        if includes.include?("backlog")
          result[:backlog_content] =
            safe_read_file(File.join(cwd, ".planning", "BACKLOG.md"))
        end
        if includes.include?("project")
          result[:project_content] =
            safe_read_file(File.join(cwd, ".planning", "PROJECT.md"))
        end
        if includes.include?("config")
          result[:config_content] =
            safe_read_file(File.join(cwd, ".planning", "config.json"))
        end

        Output.json(result, raw: raw)
      end

      # --- Private helpers ---

      def self.find_plan_internal(cwd, plan_num)
        return nil unless plan_num

        plans_dir = File.join(cwd, ".planning", "plans")
        normalized = normalize_plan_number(plan_num)

        return nil unless File.directory?(plans_dir)

        dirs = Dir.children(plans_dir).select { |d| File.directory?(File.join(plans_dir, d)) }.sort
        match = dirs.find { |d| d.start_with?("#{normalized}-") || d == normalized }
        return nil unless match

        dir_match = match.match(/\A(\d+)-?(.*)/)
        plan_number = dir_match ? dir_match[1] : normalized
        plan_name = dir_match && !dir_match[2].empty? ? dir_match[2] : nil
        plan_slug = plan_name ? plan_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "") : nil

        plan_dir = File.join(plans_dir, match)
        plan_files = Dir.children(plan_dir)

        plans = plan_files.select { |f| f.end_with?("-PLAN.md") || f == "PLAN.md" }.sort
        summaries = plan_files.select { |f| f.end_with?("-SUMMARY.md") || f == "SUMMARY.md" }.sort
        has_research = plan_files.any? { |f| f.end_with?("-RESEARCH.md") || f == "RESEARCH.md" }

        completed_plan_ids = summaries.map { |s| s.sub(/-SUMMARY\.md$/, "").sub(/\ASUMMARY\.md$/, "") }
        incomplete_plans = plans.reject do |p|
          plan_id = p.sub(/-PLAN\.md$/, "").sub(/\APLAN\.md$/, "")
          completed_plan_ids.include?(plan_id)
        end

        {
          directory: File.join(".planning", "plans", match),
          plan_number: plan_number,
          plan_name: plan_name,
          plan_slug: plan_slug,
          plans: plans,
          summaries: summaries,
          incomplete_plans: incomplete_plans,
          has_research: has_research
        }
      rescue StandardError
        nil
      end

      def self.resolve_model(cwd, agent_type)
        config = ConfigManager.load_config(cwd)
        profile = config["model_profile"] || "balanced"
        ModelProfiles.resolve_model(agent_type, profile)
      end

      def self.path_exists?(cwd, relative_path)
        File.exist?(File.join(cwd, relative_path))
      end

      def self.safe_read_file(path)
        File.read(path)
      rescue StandardError
        nil
      end

      def self.generate_slug(text)
        return nil unless text

        text.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
      end

      def self.normalize_plan_number(plan_num)
        match = plan_num.to_s.match(/\A(\d+)/)
        return plan_num.to_s unless match

        match[1].rjust(3, "0")
      end

      def self.parse_include_flag(argv)
        idx = argv.index("--include")
        return [] unless idx

        value = argv[idx + 1]
        return [] unless value

        value.split(",").map(&:strip)
      end

      private_class_method :find_plan_internal, :resolve_model,
                           :path_exists?, :safe_read_file, :generate_slug,
                           :normalize_plan_number, :parse_include_flag
    end
  end
end
