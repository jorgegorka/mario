require "fileutils"
require "json"
require_relative "output"

module MarketingMario
  module Tools
    module ConfigManager
      DEFAULTS = {
        "model_profile" => "balanced",
        "commit_docs" => true,
        "search_gitignored" => false,
        "research" => true,
        "execution_mode" => "vertical",
        "team_execution" => false
      }.freeze

      def self.load_config(cwd = Dir.pwd)
        config_path = File.join(cwd, PLANNING_DIR, "config.json")
        return DEFAULTS.dup unless File.exist?(config_path)

        parsed = JSON.parse(File.read(config_path))
        nil_or = ->(val, default) { val.nil? ? default : val }

        DEFAULTS.each_with_object({}) do |(key, default), config|
          config[key] = if [true, false].include?(default)
                          nil_or.call(parsed[key], default)
                        else
                          parsed[key] || default
                        end
        end
      rescue JSON::ParserError
        DEFAULTS.dup
      end

      def self.ensure_section(_argv, raw: false)
        cwd = Dir.pwd
        config_path = File.join(cwd, PLANNING_DIR, "config.json")
        planning_dir = File.join(cwd, PLANNING_DIR)

        FileUtils.mkdir_p(planning_dir) unless File.directory?(planning_dir)

        if File.exist?(config_path)
          Output.json({ created: false, reason: "already_exists" }, raw: raw, raw_value: "exists")
          return
        end

        File.write(config_path, JSON.pretty_generate(DEFAULTS))
        Output.json({ created: true, path: "#{PLANNING_DIR}/config.json" }, raw: raw, raw_value: "created")
      end

      def self.set(argv, raw: false)
        key_path = argv[0]
        value = argv[1]
        Output.error("Usage: config-set <key.path> <value>") unless key_path

        cwd = Dir.pwd
        config_path = File.join(cwd, PLANNING_DIR, "config.json")

        config = {}
        config = JSON.parse(File.read(config_path)) if File.exist?(config_path)

        parsed_value = case value
                       when "true" then true
                       when "false" then false
                       when /\A\d+\z/ then value.to_i
                       else value
                       end

        keys = key_path.split(".")
        current = config
        keys[0..-2].each do |key|
          current[key] = {} unless current[key].is_a?(Hash)
          current = current[key]
        end
        current[keys.last] = parsed_value

        File.write(config_path, JSON.pretty_generate(config))
        Output.json({ updated: true, key: key_path, value: parsed_value }, raw: raw,
                                                                           raw_value: "#{key_path}=#{parsed_value}")
      rescue JSON::ParserError => e
        Output.error("Failed to read config.json: #{e.message}")
      end
    end
  end
end
