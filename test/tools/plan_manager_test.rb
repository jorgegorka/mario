require "test_helper"
require "mario/tools/plan_manager"

class PlanManagerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @plans_dir = File.join(@dir, ".planning", "plans")
    FileUtils.mkdir_p(@plans_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_normalize_plan_number
    pm = Mario::Tools::PlanManager
    assert_equal "001", pm.send(:normalize_plan_number, "1")
    assert_equal "010", pm.send(:normalize_plan_number, "10")
    assert_equal "100", pm.send(:normalize_plan_number, "100")
  end

  def test_find_plan_on_disk
    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.find(["1"]) }
      assert result[:found]
      assert_equal "001", result[:plan_number]
      assert_equal "setup", result[:plan_name]
      assert_equal ".planning/plans/001-setup", result[:directory]
    end
  end

  def test_find_plan_not_found
    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.find(["99"]) }
      refute result[:found]
      assert_nil result[:directory]
    end
  end

  def test_list_plans
    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))
    FileUtils.mkdir_p(File.join(@plans_dir, "002-auth"))
    FileUtils.mkdir_p(File.join(@plans_dir, "003-api"))

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.list({}) }
      assert_equal 3, result[:count]
      assert_equal %w[001-setup 002-auth 003-api], result[:directories]
    end
  end

  def test_list_plans_with_type_filter
    plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan_dir)
    File.write(File.join(plan_dir, "PLAN.md"), "plan content")
    File.write(File.join(plan_dir, "SUMMARY.md"), "summary content")

    Dir.chdir(@dir) do
      plans_result = capture_json { Mario::Tools::PlanManager.list({ type: "plans" }) }
      assert_equal 1, plans_result[:count]
      assert_includes plans_result[:files], "PLAN.md"

      summaries_result = capture_json { Mario::Tools::PlanManager.list({ type: "summaries" }) }
      assert_equal 1, summaries_result[:count]
      assert_includes summaries_result[:files], "SUMMARY.md"
    end
  end

  def test_add_plan
    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.dispatch(["add", "Brand Positioning"]) }
      assert result[:added]
      assert_equal "001", result[:plan]
      assert_equal "001-brand-positioning", result[:directory]
      assert File.directory?(File.join(@plans_dir, "001-brand-positioning"))
    end
  end

  def test_add_plan_increments
    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.dispatch(["add", "Auth System"]) }
      assert result[:added]
      assert_equal "002", result[:plan]
    end
  end

  def test_complete_plan
    backlog_path = File.join(@dir, ".planning", "BACKLOG.md")
    File.write(backlog_path, "## Plans\n\n- [ ] **001: Setup** — Initial setup\n")

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.dispatch(["complete", "1"]) }
      assert result[:completed]
      assert_equal "001", result[:plan]

      content = File.read(backlog_path)
      assert_includes content, "- [x] **001:"
    end
  end

  def test_remove_plan_empty
    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.dispatch(["remove", "1"]) }
      assert result[:removed]
      assert_equal "001", result[:plan]
      refute File.directory?(File.join(@plans_dir, "001-setup"))
    end
  end

  def test_remove_plan_with_content_requires_force
    plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan_dir)
    File.write(File.join(plan_dir, "PLAN.md"), "content")

    Dir.chdir(@dir) do
      result = capture_json { Mario::Tools::PlanManager.dispatch(["remove", "1"]) }
      refute result[:removed]
      assert_includes result[:reason], "--force"
      assert File.directory?(plan_dir)

      result = capture_json { Mario::Tools::PlanManager.dispatch(["remove", "1", "--force"]) }
      assert result[:removed]
      refute File.directory?(plan_dir)
    end
  end

  private

  def capture_json(&block)
    output = capture_output(&block)
    JSON.parse(output, symbolize_names: true)
  end

  def capture_output
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
  rescue SystemExit
  ensure
    result = $stdout.string
    $stdout = old_stdout
    return result
  end
end
