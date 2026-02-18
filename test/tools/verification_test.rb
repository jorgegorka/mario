require "test_helper"
require "marketing_mario/tools/verification"

class VerificationTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, ".planning")
    @plans_dir = File.join(@planning_dir, "plans")
    FileUtils.mkdir_p(@plans_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_verify_summary_passes_for_valid_summary
    summary = <<~MD
      ---
      plan: 001-setup
      ---

      # Summary

      ## Self-Check
      All checks pass ✅
    MD
    File.write(File.join(@planning_dir, "test-SUMMARY.md"), summary)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_summary([".planning/test-SUMMARY.md"]) }
      assert result[:passed]
      assert result[:checks][:summary_exists]
    end
  end

  def test_verify_summary_fails_for_missing_file
    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_summary([".planning/missing-SUMMARY.md"]) }
      refute result[:passed]
      refute result[:checks][:summary_exists]
    end
  end

  def test_verify_summary_detects_failed_self_check
    summary = "---\nplan: 001\n---\n\n## Self-Check\nSome tests failed ❌\n"
    File.write(File.join(@planning_dir, "bad-SUMMARY.md"), summary)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_summary([".planning/bad-SUMMARY.md"]) }
      refute result[:passed]
      assert_equal "failed", result[:checks][:self_check]
    end
  end

  def test_verify_plan_structure_valid
    plan = <<~MD
      ---
      plan: 001-setup
      type: execute
      depends_on: []
      files_modified: []
      autonomous: true
      must_haves:
        truths: []
        artifacts: []
        key_links: []
      ---

      # Plan

      <task type="code">
        <name>Create files</name>
        <files>src/main.rb</files>
        <action>Create the main file</action>
        <verify>File exists</verify>
        <done>File created</done>
      </task>
    MD
    File.write(File.join(@dir, "test-PLAN.md"), plan)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_plan_structure("test-PLAN.md") }
      assert result[:valid]
      assert_equal 1, result[:task_count]
      assert_empty result[:errors]
    end
  end

  def test_verify_plan_structure_missing_fields
    plan = "---\ntype: execute\n---\n\n# Plan\n"
    File.write(File.join(@dir, "bad-PLAN.md"), plan)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_plan_structure("bad-PLAN.md") }
      refute result[:valid]
      assert result[:errors].any? { |e| e.include?("Missing required frontmatter") }
    end
  end

  def test_verify_references_finds_existing_files
    FileUtils.mkdir_p(File.join(@dir, "src"))
    File.write(File.join(@dir, "src", "main.rb"), "code")

    content = "Check `src/main.rb` and @src/main.rb for details."
    File.write(File.join(@dir, "test.md"), content)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_references("test.md") }
      assert result[:valid]
      assert_equal 0, result[:missing].length
    end
  end

  def test_verify_references_reports_missing
    content = "Check `nonexistent/file.rb` for details."
    File.write(File.join(@dir, "test.md"), content)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.verify_references("test.md") }
      refute result[:valid]
      assert_includes result[:missing], "nonexistent/file.rb"
    end
  end

  def test_validate_consistency_passes
    backlog = "# BACKLOG\n\n**001: Setup**\n\nGoal: TBD\n\n**002: Auth**\n\nGoal: TBD\n"
    File.write(File.join(@planning_dir, "BACKLOG.md"), backlog)

    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))
    FileUtils.mkdir_p(File.join(@plans_dir, "002-auth"))
    File.write(File.join(@plans_dir, "001-setup", "PLAN.md"), "plan")
    File.write(File.join(@plans_dir, "002-auth", "PLAN.md"), "plan")

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.validate_consistency }
      assert result[:passed]
      assert_empty result[:errors]
    end
  end

  def test_validate_consistency_detects_gaps
    backlog = "# BACKLOG\n\n**001: Setup**\n\n**003: Deploy**\n"
    File.write(File.join(@planning_dir, "BACKLOG.md"), backlog)

    FileUtils.mkdir_p(File.join(@plans_dir, "001-setup"))
    FileUtils.mkdir_p(File.join(@plans_dir, "003-deploy"))

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.validate_consistency }
      assert result[:passed] # gaps are warnings, not errors
      assert result[:warnings].any? { |w| w.include?("Gap in plan numbering") }
    end
  end

  def test_validate_consistency_no_backlog
    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::Verification.validate_consistency }
      refute result[:passed]
      assert_includes result[:errors], "BACKLOG.md not found"
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
