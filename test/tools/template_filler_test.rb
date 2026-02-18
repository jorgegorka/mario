require "test_helper"
require "marketing_mario/tools/template_filler"

class TemplateFillerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, ".planning")
    @plans_dir = File.join(@planning_dir, "plans")
    @plan_dir = File.join(@plans_dir, "001-setup")
    FileUtils.mkdir_p(@plan_dir)
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_select_minimal_template
    plan = "---\nplan: 001-setup\n---\n\n# Plan\n\n### Task 1\nDo something\n"
    File.write(File.join(@dir, "test-PLAN.md"), plan)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::TemplateFiller.select("test-PLAN.md") }
      assert_equal "minimal", result[:type]
      assert_includes result[:template], "minimal"
    end
  end

  def test_select_complex_template
    plan = "---\nplan: 001-setup\n---\n\n# Plan\n\n"
    plan += (1..6).map { |i| "### Task #{i}\nDo something with `src/file#{i}.rb`\n\nA decision was made.\n" }.join("\n")
    File.write(File.join(@dir, "complex-PLAN.md"), plan)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::TemplateFiller.select("complex-PLAN.md") }
      assert_equal "complex", result[:type]
    end
  end

  def test_select_standard_template
    plan = "---\nplan: 001-setup\n---\n\n# Plan\n\n"
    plan += (1..3).map { |i| "### Task #{i}\nDo something with `src/path/file#{i}.rb`\n" }.join("\n")
    File.write(File.join(@dir, "std-PLAN.md"), plan)

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::TemplateFiller.select("std-PLAN.md") }
      assert_equal "standard", result[:type]
    end
  end

  def test_fill_summary_template
    Dir.chdir(@dir) do
      result = capture_json do
        MarketingMario::Tools::TemplateFiller.fill("summary", { plan: "1", name: "Setup" })
      end
      assert result[:created]
      assert_includes result[:path], "SUMMARY.md"
      assert File.exist?(File.join(@dir, result[:path]))
    end
  end

  def test_fill_plan_template
    Dir.chdir(@dir) do
      result = capture_json do
        MarketingMario::Tools::TemplateFiller.fill("plan", { plan: "1", type: "execute" })
      end
      assert result[:created]
      assert_includes result[:path], "PLAN.md"

      content = File.read(File.join(@dir, result[:path]))
      assert_includes content, "## Objective"
      assert_includes content, "## Tasks"
    end
  end

  def test_fill_does_not_overwrite
    File.write(File.join(@plan_dir, "SUMMARY.md"), "existing")

    Dir.chdir(@dir) do
      result = capture_json do
        MarketingMario::Tools::TemplateFiller.fill("summary", { plan: "1" })
      end
      assert result[:error]
      assert_includes result[:error], "already exists"
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
