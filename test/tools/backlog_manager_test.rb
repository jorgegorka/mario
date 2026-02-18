require "test_helper"
require "marketing_mario/tools/backlog_manager"

class BacklogManagerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, ".planning")
    FileUtils.mkdir_p(@planning_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_analyze_backlog
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test Project

      ## Plans

      - [x] **001: Brand Positioning** — Define voice
      - [ ] **002: Homepage Copy** — Hero, benefits

      ## Upcoming

      - Blog strategy

      ## Completed

      | # | Plan | Completed | Commit |
      |---|------|-----------|--------|
      | 001 | Brand Positioning | 2026-02-10 | abc1234 |
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["analyze"]) }
      assert_equal 2, result[:plan_count]
      assert_equal 1, result[:completed_plans]
      assert_equal 50, result[:progress_percent]
      assert_equal "002", result[:current_plan]
      assert_equal "Test Project", result[:project_name]
    end
  end

  def test_analyze_empty_backlog
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Empty Project

      ## Plans

      ## Upcoming

      ## Completed
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["analyze"]) }
      assert_equal 0, result[:plan_count]
      assert_equal 0, result[:completed_plans]
      assert_equal 0, result[:progress_percent]
      assert_nil result[:current_plan]
    end
  end

  def test_analyze_no_backlog
    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["analyze"]) }
      assert_equal "BACKLOG.md not found", result[:error]
      assert_empty result[:plans]
      assert_nil result[:current_plan]
    end
  end

  def test_get_plan
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test

      ## Plans

      - [x] **001: Brand Positioning** — Define voice
      - [ ] **002: Homepage Copy** — Hero, benefits
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["get", "1"]) }
      assert result[:found]
      assert_equal "001", result[:number]
      assert_equal "Brand Positioning", result[:name]
      assert result[:done]
    end
  end

  def test_get_plan_not_found
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test

      ## Plans

      - [ ] **001: Setup** — Init
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["get", "99"]) }
      refute result[:found]
      assert_equal "099", result[:plan_number]
    end
  end

  def test_add_plan
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test

      ## Plans

      - [ ] **001: Setup** — Init

      ## Upcoming

      - Future work
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["add", "Blog Strategy"]) }
      assert result[:added]
      assert_equal "002", result[:plan]
      assert_equal "Blog Strategy", result[:description]

      content = File.read(File.join(@planning_dir, "BACKLOG.md"))
      assert_includes content, "**002: Blog Strategy**"
    end
  end

  def test_add_plan_increments_number
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test

      ## Plans

      - [x] **001: First** — Done
      - [ ] **002: Second** — Pending

      ## Upcoming
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["add", "Third Plan"]) }
      assert result[:added]
      assert_equal "003", result[:plan]
    end
  end

  def test_complete_plan
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test

      ## Plans

      - [ ] **001: Brand Positioning** — Define voice

      ## Completed

      | # | Plan | Completed | Commit |
      |---|------|-----------|--------|
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.dispatch(["complete", "1", "--commit", "abc1234"]) }
      assert result[:completed]
      assert_equal "001", result[:plan]
      assert_equal "abc1234", result[:commit]

      content = File.read(File.join(@planning_dir, "BACKLOG.md"))
      assert_includes content, "- [x] **001:"
      assert_includes content, "| 001 | Brand Positioning"
    end
  end

  def test_progress_json
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test Project

      ## Plans

      - [x] **001: Setup** — Done
      - [ ] **002: Auth** — Pending
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.progress(["json"]) }
      assert_equal 2, result[:total_plans]
      assert_equal 1, result[:completed_plans]
      assert_equal 50, result[:percent]
      assert_equal "Test Project", result[:project_name]
    end
  end

  def test_progress_bar
    File.write(File.join(@planning_dir, "BACKLOG.md"), <<~MD)
      # Backlog: Test Project

      ## Plans

      - [x] **001: Setup** — Done
      - [ ] **002: Auth** — Pending
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::BacklogManager.progress(["bar"]) }
      assert_equal 50, result[:percent]
      assert_includes result[:bar], "1/2 plans"
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
