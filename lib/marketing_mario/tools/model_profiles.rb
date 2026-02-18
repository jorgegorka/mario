require "json"
require_relative "output"
require_relative "config_manager"

module MarketingMario
  module Tools
    module ModelProfiles
      PROFILES = {
        "mario-planner" =>              { "quality" => "opus", "balanced" => "opus",   "budget" => "sonnet" },
        "mario-roadmapper" =>           { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" },
        "mario-executor" =>             { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" },
        "mario-phase-researcher" =>     { "quality" => "opus", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-project-researcher" =>   { "quality" => "opus", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-research-synthesizer" => { "quality" => "sonnet", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-topic-researcher" =>     { "quality" => "opus", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-debugger" =>             { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" },
        "mario-codebase-mapper" =>      { "quality" => "sonnet", "balanced" => "haiku", "budget" => "haiku" },
        "mario-verifier" =>             { "quality" => "sonnet", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-plan-checker" =>         { "quality" => "sonnet", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-integration-checker" =>  { "quality" => "sonnet", "balanced" => "sonnet", "budget" => "haiku" },
        "mario-backend-executor" =>   { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" },
        "mario-frontend-executor" =>  { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" },
        "mario-test-executor" =>      { "quality" => "opus", "balanced" => "sonnet", "budget" => "sonnet" }
      }.freeze

      def self.resolve(argv, raw: false)
        agent_type = argv.first
        Output.error("agent-type required") unless agent_type

        config = ConfigManager.load_config
        profile = config["model_profile"] || "balanced"

        agent_models = PROFILES[agent_type]
        unless agent_models
          Output.json({ model: "sonnet", profile: profile, unknown_agent: true }, raw: raw, raw_value: "sonnet")
          return
        end

        model = agent_models[profile] || agent_models["balanced"] || "sonnet"
        Output.json({ model: model, profile: profile }, raw: raw, raw_value: model)
      end

      def self.resolve_model(agent_type, profile = "balanced")
        agent_models = PROFILES[agent_type]
        return "sonnet" unless agent_models

        agent_models[profile] || agent_models["balanced"] || "sonnet"
      end
    end
  end
end
