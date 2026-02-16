require "json"
require "fileutils"
require_relative "output"
require_relative "frontmatter"

module Mario
  module Tools
    module TemplateManager
      PROJECT_DIR = ".planning/templates".freeze
      GLOBAL_DIR = File.join(Dir.home, ".claude", "mario", "templates", "recurring")

      def self.dispatch(argv, raw: false)
        subcommand = argv.shift
        case subcommand
        when "list"
          list(raw: raw)
        when "get"
          name = argv.shift
          get(name, raw: raw)
        when "fill"
          name = argv.shift
          variables_json = argv.shift
          fill(name, variables_json, raw: raw)
        when "save"
          plan_path = argv.shift
          template_name = argv.shift
          save(plan_path, template_name, raw: raw)
        else
          Output.error("Unknown template-manager subcommand. Available: list, get, fill, save")
        end
      end

      def self.list(raw: false)
        templates = {}

        scan_directory(global_dir, "global").each do |t|
          templates[t[:name]] = t
        end

        scan_directory(project_dir, "project").each do |t|
          templates[t[:name]] = t
        end

        result = templates.values.sort_by { |t| t[:name] }
        Output.json(result, raw: raw)
      end

      def self.get(name, raw: false)
        Output.error("Template name required") unless name && !name.empty?

        path = find_template(name)
        Output.error("Template not found: #{name}") unless path

        content = File.read(path)
        fm = Frontmatter.extract(content)
        body = Frontmatter.body(content)
        variables = parse_variables(fm)

        Output.json({
                      name: fm["name"] || name,
                      description: fm["description"] || "",
                      variables: variables,
                      body: body,
                      path: path
                    }, raw: raw)
      end

      def self.fill(name, variables_json, raw: false)
        Output.error("Template name required") unless name && !name.empty?

        path = find_template(name)
        Output.error("Template not found: #{name}") unless path

        content = File.read(path)
        fm = Frontmatter.extract(content)
        body = Frontmatter.body(content)
        variables = parse_variables(fm)

        provided = variables_json ? JSON.parse(variables_json) : {}

        missing = variables.select { |v| v[:required] && !provided.key?(v[:name]) }
        unless missing.empty?
          names = missing.map { |v| v[:name] }
          Output.error("Missing required variables: #{names.join(', ')}")
        end

        filled = body.dup
        variables.each do |v|
          value = provided[v[:name]] || v[:default] || ""
          filled.gsub!("{{#{v[:name]}}}", value.to_s)
        end

        Output.json({ name: fm["name"] || name, filled: filled }, raw: raw, raw_value: filled)
      rescue JSON::ParserError
        Output.error("Invalid JSON for variables")
      end

      def self.save(plan_path, template_name, raw: false)
        Output.error("Plan path required") unless plan_path && !plan_path.empty?
        Output.error("Template name required") unless template_name && !template_name.empty?

        cwd = Dir.pwd
        full_path = File.expand_path(plan_path, cwd)
        Output.error("Plan not found: #{plan_path}") unless File.exist?(full_path)

        content = File.read(full_path)
        body = Frontmatter.body(content)

        slug = template_name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")
        templates_dir = File.join(cwd, PROJECT_DIR)
        FileUtils.mkdir_p(templates_dir)
        out_path = File.join(templates_dir, "#{slug}.md")

        fm = {
          "name" => template_name,
          "description" => "Template created from #{File.basename(plan_path)}",
          "variables" => []
        }

        yaml_str = Frontmatter.reconstruct(fm)
        template_content = "---\n#{yaml_str}\n---\n\n#{body}\n"

        File.write(out_path, template_content)
        rel_path = out_path.sub("#{cwd}/", "")
        Output.json({ saved: true, path: rel_path, name: template_name }, raw: raw, raw_value: rel_path)
      end

      # --- Private helpers ---

      def self.project_dir
        File.join(Dir.pwd, PROJECT_DIR)
      end

      def self.global_dir
        GLOBAL_DIR
      end

      def self.scan_directory(dir, source)
        return [] unless File.directory?(dir)

        Dir.glob(File.join(dir, "*.md")).map do |path|
          content = File.read(path)
          fm = Frontmatter.extract(content)
          {
            name: fm["name"] || File.basename(path, ".md"),
            description: fm["description"] || "",
            source: source,
            path: path
          }
        end
      end

      def self.find_template(name)
        slug = name.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/\A-+|-+\z/, "")

        # Project templates override global
        project = find_in_directory(project_dir, name, slug)
        return project if project

        find_in_directory(global_dir, name, slug)
      end

      def self.find_in_directory(dir, name, slug)
        return nil unless File.directory?(dir)

        # Try exact slug match first
        path = File.join(dir, "#{slug}.md")
        return path if File.exist?(path)

        # Try matching by frontmatter name
        Dir.glob(File.join(dir, "*.md")).each do |path|
          content = File.read(path)
          fm = Frontmatter.extract(content)
          return path if fm["name"]&.downcase == name.downcase
        end

        nil
      end

      def self.parse_variables(fm)
        vars = fm["variables"]
        return [] unless vars.is_a?(Array)

        vars.map do |v|
          if v.is_a?(Hash)
            {
              name: v["name"],
              description: v["description"] || "",
              required: v["required"].to_s != "false",
              default: v["default"] || ""
            }
          elsif v.is_a?(String)
            { name: v, description: "", required: true, default: "" }
          end
        end.compact
      end

      private_class_method :project_dir, :global_dir, :scan_directory, :find_template,
                           :find_in_directory, :parse_variables
    end
  end
end
