require_relative "lib/marketing_mario/version"

Gem::Specification.new do |s|
  s.name        = "marketing_mario"
  s.version     = MarketingMario::VERSION
  s.summary     = "A marketing meta-prompting and context engineering system for Claude Code"
  s.description = "Mario generates and executes marketing plans via structured " \
                  "planning, multi-agent orchestration, and verification workflows via Claude Code " \
                  "slash commands."
  s.authors     = ["Jorge Alvarez"]
  s.email       = "jorge@alvareznavarro.es"
  s.homepage    = "https://github.com/jorgegorka/mario"
  s.license     = "MIT"

  s.required_ruby_version = ">= 3.1.0"

  s.files = Dir.chdir(__dir__) do
    Dir["{lib,exe,data}/**/*", "LICENSE", "*.gemspec"].reject { |f| File.directory?(f) }
  end

  s.bindir      = "exe"
  s.executables  = %w[mario mario-tools]

  s.metadata = {
    "homepage_uri"    => s.homepage,
    "source_code_uri" => s.homepage,
    "changelog_uri"   => "#{s.homepage}/blob/master/CHANGELOG.md"
  }
end
