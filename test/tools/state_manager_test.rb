require "test_helper"
require "marketing_mario/tools/state_manager"

class StateManagerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, MarketingMario::PLANNING_DIR)
    FileUtils.mkdir_p(@planning_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def write_state(content)
    File.write(File.join(@planning_dir, "STATE.md"), content)
  end

  def read_state
    File.read(File.join(@planning_dir, "STATE.md"))
  end

  def test_extract_field
    content = "**Phase:** 2 of 5 (Auth)\n**Status:** In progress"
    # Use send to test private method
    assert_equal "2 of 5 (Auth)", MarketingMario::Tools::StateManager.send(:extract_field, content, "Phase")
    assert_equal "In progress", MarketingMario::Tools::StateManager.send(:extract_field, content, "Status")
    assert_nil MarketingMario::Tools::StateManager.send(:extract_field, content, "Missing")
  end

  def test_replace_field
    content = "**Status:** Planning\n**Phase:** 1"
    result = MarketingMario::Tools::StateManager.send(:replace_field, content, "Status", "In progress")
    assert_includes result, "**Status:** In progress"
    assert_includes result, "**Phase:** 1"
  end

  def test_replace_field_not_found
    content = "**Status:** Planning"
    result = MarketingMario::Tools::StateManager.send(:replace_field, content, "Missing", "value")
    assert_nil result
  end

  def test_state_patch_updates_multiple_fields
    write_state("# State\n\n**Phase:** 1\n**Status:** Ready\n**Plan:** 0\n")

    Dir.chdir(@dir) do
      content = read_state
      patches = { "Status" => "In progress", "Plan" => "1" }

      results = { updated: [], failed: [] }
      patches.each do |field, value|
        new_content = MarketingMario::Tools::StateManager.send(:replace_field, content, field, value)
        if new_content
          content = new_content
          results[:updated] << field
        else
          results[:failed] << field
        end
      end

      File.write(File.join(@planning_dir, "STATE.md"), content)

      assert_equal %w[Status Plan], results[:updated]
      assert_empty results[:failed]
      assert_includes read_state, "**Status:** In progress"
      assert_includes read_state, "**Plan:** 1"
    end
  end
end
