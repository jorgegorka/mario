require "test_helper"
require "marketing_mario/tools/config_manager"

class ConfigManagerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, ".planning")
    FileUtils.mkdir_p(@planning_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_load_defaults_when_no_config
    config = MarketingMario::Tools::ConfigManager.load_config(@dir)
    assert_equal "balanced", config["model_profile"]
    assert_equal true, config["commit_docs"]
    assert_equal true, config["research"]
    assert_equal "vertical", config["execution_mode"]
    assert_equal false, config["team_execution"]
  end

  def test_load_custom_config
    config_data = {
      "model_profile" => "quality",
      "commit_docs" => false
    }
    File.write(File.join(@planning_dir, "config.json"), JSON.pretty_generate(config_data))

    config = MarketingMario::Tools::ConfigManager.load_config(@dir)
    assert_equal "quality", config["model_profile"]
    assert_equal false, config["commit_docs"]
  end

  def test_load_malformed_json_returns_defaults
    File.write(File.join(@planning_dir, "config.json"), "not json")
    config = MarketingMario::Tools::ConfigManager.load_config(@dir)
    assert_equal "balanced", config["model_profile"]
  end

  def test_load_defaults_include_execution_mode
    config = MarketingMario::Tools::ConfigManager.load_config(@dir)
    assert_equal "vertical", config["execution_mode"]
    assert_equal false, config["team_execution"]
  end

  def test_load_custom_execution_mode
    config_data = {
      "execution_mode" => "domain-split",
      "team_execution" => true
    }
    File.write(File.join(@planning_dir, "config.json"), JSON.pretty_generate(config_data))

    config = MarketingMario::Tools::ConfigManager.load_config(@dir)
    assert_equal "domain-split", config["execution_mode"]
    assert_equal true, config["team_execution"]
  end
end
