require "test_helper"
require "mario/tools/model_profiles"

class ModelProfilesTest < Minitest::Test
  def test_resolve_model_balanced
    assert_equal "opus", Mario::Tools::ModelProfiles.resolve_model("mario-planner", "balanced")
    assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model("mario-executor", "balanced")
    assert_equal "haiku", Mario::Tools::ModelProfiles.resolve_model("mario-codebase-mapper", "balanced")
  end

  def test_resolve_model_quality
    assert_equal "opus", Mario::Tools::ModelProfiles.resolve_model("mario-planner", "quality")
    assert_equal "opus", Mario::Tools::ModelProfiles.resolve_model("mario-executor", "quality")
    assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model("mario-codebase-mapper", "quality")
  end

  def test_resolve_model_budget
    assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model("mario-planner", "budget")
    assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model("mario-executor", "budget")
    assert_equal "haiku", Mario::Tools::ModelProfiles.resolve_model("mario-codebase-mapper", "budget")
  end

  def test_resolve_unknown_agent
    assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model("unknown-agent", "balanced")
  end

  def test_all_agents_have_profiles
    expected = %w[
      mario-planner mario-roadmapper mario-executor
      mario-phase-researcher mario-project-researcher
      mario-research-synthesizer mario-debugger
      mario-codebase-mapper mario-verifier
      mario-plan-checker mario-integration-checker
      mario-backend-executor mario-frontend-executor
      mario-test-executor
    ]
    expected.each do |agent|
      refute_nil Mario::Tools::ModelProfiles::PROFILES[agent], "Missing profile for #{agent}"
    end
  end

  def test_domain_executor_profiles
    %w[mario-backend-executor mario-frontend-executor mario-test-executor].each do |agent|
      assert_equal "opus", Mario::Tools::ModelProfiles.resolve_model(agent, "quality")
      assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model(agent, "balanced")
      assert_equal "sonnet", Mario::Tools::ModelProfiles.resolve_model(agent, "budget")
    end
  end
end
