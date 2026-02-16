require "json"
require "fileutils"
require_relative "output"
require_relative "frontmatter"

module Mario
  module Tools
    module TemplateFiller
      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "fill"
          template_type = argv.shift
          options = parse_options(argv)
          fill(template_type, options, raw: raw)
        when "select"
          select(argv.first, raw: raw)
        else
          Output.error("Unknown template subcommand. Available: fill, select")
        end
      end

      def self.select(plan_path, raw: false)
        Output.error("plan-path required") unless plan_path

        cwd = Dir.pwd
        full_path = File.join(cwd, plan_path)

        begin
          content = File.read(full_path)
          task_matches = content.scan(/###\s*Task\s*\d+/i)
          task_count = task_matches.length

          has_decisions = content.match?(/decision/i)

          file_mentions = []
          content.scan(/`([^`]+\.[a-zA-Z]+)`/) do
            f = ::Regexp.last_match(1)
            file_mentions << f if f.include?("/") && !f.start_with?("http") && !file_mentions.include?(f)
          end
          file_count = file_mentions.length

          template = "templates/summary-standard.md"
          type = "standard"

          if task_count <= 2 && file_count <= 3 && !has_decisions
            template = "templates/summary-minimal.md"
            type = "minimal"
          elsif has_decisions || file_count > 6 || task_count > 5
            template = "templates/summary-complex.md"
            type = "complex"
          end

          Output.json({ template: template, type: type, taskCount: task_count, fileCount: file_count, hasDecisions: has_decisions },
                      raw: raw, raw_value: template)
        rescue StandardError => e
          Output.json({ template: "templates/summary-standard.md", type: "standard", error: e.message },
                      raw: raw, raw_value: "templates/summary-standard.md")
        end
      end

      def self.fill(template_type, options, raw: false)
        Output.error("template type required: summary or plan") unless template_type
        Output.error("--plan required") unless options[:plan]

        cwd = Dir.pwd
        plan_info = find_plan_internal(cwd, options[:plan])

        unless plan_info
          Output.json({ error: "Plan not found", plan: options[:plan] }, raw: raw)
          return
        end

        padded = normalize_plan(options[:plan])
        today = Time.now.utc.strftime("%Y-%m-%d")
        plan_name = options[:name] || plan_info[:plan_name] || "Unnamed"
        plan_slug = plan_info[:plan_slug] || generate_slug(plan_name)
        plan_id = "#{padded}-#{plan_slug}"
        fields = options[:fields] || {}

        frontmatter = nil
        body = nil
        file_name = nil

        case template_type
        when "summary"
          frontmatter = {
            "plan" => plan_id, "subsystem" => "[primary category]",
            "tags" => [], "provides" => [], "affects" => [],
            "tech-stack" => { "added" => [], "patterns" => [] },
            "key-files" => { "created" => [], "modified" => [] },
            "key-decisions" => [], "patterns-established" => [],
            "duration" => "[X]min", "completed" => today
          }.merge(fields)

          body = [
            "# Plan #{options[:plan]}: #{plan_name} Summary", "",
            "**[Substantive one-liner describing outcome]**", "",
            "## Performance",
            "- **Duration:** [time]", "- **Tasks:** [count completed]", "- **Files modified:** [count]", "",
            "## Accomplishments", "- [Key outcome 1]", "- [Key outcome 2]", "",
            "## Task Commits", "1. **Task 1: [task name]** - `hash`", "",
            "## Files Created/Modified", "- `path/to/file.ts` - What it does", "",
            "## Decisions & Deviations", "[Key decisions or \"None - followed plan as specified\"]", "",
            "## Next Plan Readiness", "[What's ready for next plan]"
          ].join("\n")
          file_name = "SUMMARY.md"

        when "plan"
          plan_type = options[:type] || "execute"
          frontmatter = {
            "plan" => plan_id, "type" => plan_type,
            "depends_on" => [], "files_modified" => [], "autonomous" => true,
            "user_setup" => [],
            "must_haves" => { "truths" => [], "artifacts" => [], "key_links" => [] }
          }.merge(fields)

          body = [
            "# Plan #{options[:plan]}: [Title]", "",
            "## Objective",
            "- **What:** [What this plan builds]",
            "- **Why:** [Why it matters for the project goal]",
            "- **Output:** [Concrete deliverable]", "",
            "## Context",
            "@.planning/PROJECT.md", "@.planning/BACKLOG.md", "@.planning/STATE.md", "",
            "## Tasks", "",
            "<task type=\"code\">",
            "  <name>[Task name]</name>",
            "  <files>[file paths]</files>",
            "  <action>[What to do]</action>",
            "  <verify>[How to verify]</verify>",
            "  <done>[Definition of done]</done>",
            "</task>", "",
            "## Verification", "[How to verify this plan achieved its objective]", "",
            "## Success Criteria", "- [ ] [Criterion 1]", "- [ ] [Criterion 2]"
          ].join("\n")
          file_name = "PLAN.md"

        else
          Output.error("Unknown template type: #{template_type}. Available: summary, plan")
        end

        yaml_str = Frontmatter.reconstruct(frontmatter)
        full_content = "---\n#{yaml_str}\n---\n\n#{body}\n"
        out_path = File.join(cwd, plan_info[:directory], file_name)

        if File.exist?(out_path)
          rel_path = out_path.sub("#{cwd}/", "")
          Output.json({ error: "File already exists", path: rel_path }, raw: raw)
          return
        end

        File.write(out_path, full_content)
        rel_path = out_path.sub("#{cwd}/", "")
        Output.json({ created: true, path: rel_path, template: template_type }, raw: raw, raw_value: rel_path)
      end

      # --- Private helpers ---

      def self.find_plan_internal(cwd, plan)
        plans_dir = File.join(cwd, ".planning", "plans")
        normalized = normalize_plan(plan)

        return nil unless File.directory?(plans_dir)

        dirs = Dir.children(plans_dir).select { |d| File.directory?(File.join(plans_dir, d)) }.sort
        match = dirs.find { |d| d.start_with?(normalized) }
        return nil unless match

        dir_match = match.match(/\A(\d+)-?(.*)/)
        plan_number = dir_match ? dir_match[1] : normalized
        plan_name = dir_match && !dir_match[2].empty? ? dir_match[2] : nil
        plan_slug = plan_name ? plan_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "") : nil

        { directory: File.join(".planning", "plans", match), plan_number: plan_number, plan_name: plan_name,
          plan_slug: plan_slug }
      rescue StandardError
        nil
      end

      def self.normalize_plan(plan)
        match = plan.to_s.match(/\A(\d+)/)
        return plan.to_s unless match

        match[1].rjust(3, "0")
      end

      def self.generate_slug(text)
        return nil unless text

        text.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
      end

      def self.parse_options(argv)
        result = {}
        %w[plan name type].each do |key|
          idx = argv.index("--#{key}")
          result[key.to_sym] = argv[idx + 1] if idx
        end

        fields_idx = argv.index("--fields")
        result[:fields] = fields_idx ? JSON.parse(argv[fields_idx + 1]) : {}
        result
      rescue JSON::ParserError
        result[:fields] = {}
        result
      end

      private_class_method :find_plan_internal, :normalize_plan, :generate_slug, :parse_options
    end
  end
end
