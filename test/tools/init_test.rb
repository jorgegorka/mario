require "test_helper"
require "marketing_mario/tools/init"

class InitTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, ".planning")
    @plans_dir = File.join(@planning_dir, "plans")
    FileUtils.mkdir_p(@plans_dir)

    File.write(File.join(@planning_dir, "BACKLOG.md"), "# BACKLOG\n\n**001: Setup**\n\nGoal: TBD\n")
    File.write(File.join(@planning_dir, "config.json"), '{"model_profile":"balanced"}')
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_init_execute
    plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan_dir)
    File.write(File.join(plan_dir, "PLAN.md"), "---\nplan: 001-setup\ntype: execute\n---\n")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["execute", "1"]) }
      assert result[:plan_found]
      assert_equal "001", result[:plan_number]
      assert_equal "setup", result[:plan_name]
      assert_includes result[:executor_model], "sonnet"
    end
  end

  def test_init_execute_with_includes
    plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan_dir)
    File.write(File.join(@planning_dir, "STATE.md"), "**Status:** Active\n")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["execute", "1", "--include", "state,backlog"]) }
      assert result[:state_content]
      assert result[:backlog_content]
    end
  end

  def test_init_plan
    plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan_dir)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["plan", "1"]) }
      assert result[:plan_found]
      assert_includes result.keys, :researcher_model
      assert_includes result.keys, :planner_model
      assert_includes result.keys, :research_enabled
    end
  end

  def test_init_new_project
    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["new-project"]) }
      assert_includes result.keys, :researcher_model
      assert_includes result.keys, :backlog_planner_model
      assert_includes result.keys, :is_brownfield
      assert_includes result.keys, :has_git
    end
  end

  def test_init_quick
    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["quick", "fix", "login", "bug"]) }
      assert_equal 1, result[:next_num]
      assert_equal "001", result[:padded_num]
      assert_equal "fix-login-bug", result[:slug]
      assert_includes result[:task_dir], "001-fix-login-bug"
    end
  end

  def test_init_quick_increments_number
    FileUtils.mkdir_p(File.join(@plans_dir, "001-first-task"))

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["quick", "second", "task"]) }
      assert_equal 2, result[:next_num]
    end
  end

  def test_init_progress
    plan1_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(plan1_dir)
    File.write(File.join(plan1_dir, "PLAN.md"), "plan")
    File.write(File.join(plan1_dir, "SUMMARY.md"), "summary")

    plan2_dir = File.join(@plans_dir, "002-auth")
    FileUtils.mkdir_p(plan2_dir)
    File.write(File.join(plan2_dir, "PLAN.md"), "plan")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["progress"]) }
      assert_equal 2, result[:plan_count]
      assert_equal 1, result[:completed_count]
      assert_equal 1, result[:in_progress_count]
      assert result[:has_work_in_progress]
      assert_includes result.keys, :backlog_exists
    end
  end

  def test_init_progress_detects_paused
    File.write(File.join(@planning_dir, "STATE.md"), "**Paused At:** Task 3 of Plan 02\n")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["progress"]) }
      assert_includes result.keys, :state_exists
    end
  end

  def test_init_todos
    pending_dir = File.join(@planning_dir, "todos", "pending")
    FileUtils.mkdir_p(pending_dir)
    File.write(File.join(pending_dir, "todo1.md"), "title: Fix bug\narea: code\ncreated: 2024-01-01\n")
    File.write(File.join(pending_dir, "todo2.md"), "title: Write docs\narea: docs\ncreated: 2024-01-02\n")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["todos"]) }
      assert_equal 2, result[:todo_count]
      assert_equal 2, result[:todos].length
    end
  end

  def test_init_todos_with_area_filter
    pending_dir = File.join(@planning_dir, "todos", "pending")
    FileUtils.mkdir_p(pending_dir)
    File.write(File.join(pending_dir, "todo1.md"), "title: Fix bug\narea: code\ncreated: 2024-01-01\n")
    File.write(File.join(pending_dir, "todo2.md"), "title: Write docs\narea: docs\ncreated: 2024-01-02\n")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Init.dispatch(["todos", "code"]) }
      assert_equal 1, result[:todo_count]
      assert_equal "code", result[:todos].first[:area]
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
    # Output.json calls exit(0)
  ensure
    result = $stdout.string
    $stdout = old_stdout
    return result
  end
end
