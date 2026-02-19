require "test_helper"
require "marketing_mario/tools/template_manager"

class TemplateManagerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
    @planning_dir = File.join(@dir, MarketingMario::PLANNING_DIR)
    @templates_dir = File.join(@planning_dir, "templates")
    FileUtils.mkdir_p(@templates_dir)

    @global_dir = File.join(@dir, "global_templates")
    MarketingMario::Tools::TemplateManager.define_method(:global_dir) { @global_dir } rescue nil
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_list_empty
    Dir.chdir(@dir) do
      # Use a temp dir with no templates anywhere
      tmpdir = Dir.mktmpdir
      Dir.chdir(tmpdir) do
        stub_global_dir(tmpdir) do
          result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["list"]) }
          assert_empty result
        end
      end
      FileUtils.rm_rf(tmpdir)
    end
  end

  def test_list_global_templates
    FileUtils.mkdir_p(@global_dir)
    File.write(File.join(@global_dir, "weekly-report.md"), <<~MD)
      ---
      name: Weekly Report
      description: Weekly status report template
      variables: []
      ---

      # Weekly Report
    MD

    Dir.chdir(@dir) do
      stub_global_dir(@global_dir) do
        result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["list"]) }
        assert_equal 1, result.length
        assert_equal "Weekly Report", result[0][:name]
        assert_equal "global", result[0][:source]
      end
    end
  end

  def test_list_project_templates
    File.write(File.join(@templates_dir, "campaign-brief.md"), <<~MD)
      ---
      name: Campaign Brief
      description: Marketing campaign brief
      variables: []
      ---

      # Campaign Brief
    MD

    Dir.chdir(@dir) do
      stub_global_dir(File.join(@dir, "nonexistent")) do
        result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["list"]) }
        assert_equal 1, result.length
        assert_equal "Campaign Brief", result[0][:name]
        assert_equal "project", result[0][:source]
      end
    end
  end

  def test_get_template
    File.write(File.join(@templates_dir, "blog-post.md"), <<~MD)
      ---
      name: Blog Post
      description: Blog post template
      variables: [title, author]
      ---

      # {{title}}

      By {{author}}
    MD

    Dir.chdir(@dir) do
      stub_global_dir(File.join(@dir, "nonexistent")) do
        result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["get", "blog-post"]) }
        assert_equal "Blog Post", result[:name]
        assert_equal 2, result[:variables].length
        assert_equal "title", result[:variables][0][:name]
        assert result[:variables][0][:required]
        assert_equal "author", result[:variables][1][:name]
        assert_includes result[:body], "{{title}}"
      end
    end
  end

  def test_get_template_not_found
    Dir.chdir(@dir) do
      stub_global_dir(File.join(@dir, "nonexistent")) do
        output = capture_stderr do
          capture_output { MarketingMario::Tools::TemplateManager.dispatch(["get", "nonexistent"]) }
        end
        assert_includes output, "Template not found"
      end
    end
  end

  def test_fill_template
    File.write(File.join(@templates_dir, "blog-post.md"), <<~MD)
      ---
      name: Blog Post
      description: Blog post template
      variables: [title, author]
      ---

      # {{title}}

      By {{author}}
    MD

    Dir.chdir(@dir) do
      stub_global_dir(File.join(@dir, "nonexistent")) do
        vars = '{"title":"My Great Post","author":"Jane"}'
        result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["fill", "blog-post", vars]) }
        assert_equal "Blog Post", result[:name]
        assert_includes result[:filled], "# My Great Post"
        assert_includes result[:filled], "By Jane"
      end
    end
  end

  def test_fill_template_missing_required
    File.write(File.join(@templates_dir, "blog-post.md"), <<~MD)
      ---
      name: Blog Post
      description: Blog post template
      variables: [title]
      ---

      # {{title}}
    MD

    Dir.chdir(@dir) do
      stub_global_dir(File.join(@dir, "nonexistent")) do
        output = capture_stderr do
          capture_output { MarketingMario::Tools::TemplateManager.dispatch(["fill", "blog-post", "{}"]) }
        end
        assert_includes output, "Missing required variables"
        assert_includes output, "title"
      end
    end
  end

  def test_save_template
    plan_path = File.join(@planning_dir, "plans", "001-setup", "PLAN.md")
    FileUtils.mkdir_p(File.dirname(plan_path))
    File.write(plan_path, <<~MD)
      ---
      plan: 001
      ---

      # Setup Plan

      Steps to set up the project.
    MD

    Dir.chdir(@dir) do
      result = capture_json { MarketingMario::Tools::TemplateManager.dispatch(["save", plan_path, "Setup Template"]) }
      assert result[:saved]
      assert_equal "Setup Template", result[:name]
      assert_includes result[:path], "setup-template.md"

      saved = File.read(File.join(@templates_dir, "setup-template.md"))
      assert_includes saved, "name: Setup Template"
      assert_includes saved, "# Setup Plan"
    end
  end

  private

  def stub_global_dir(dir)
    old = MarketingMario::Tools::TemplateManager.send(:global_dir)
    MarketingMario::Tools::TemplateManager.define_singleton_method(:global_dir) { dir }
    yield
  ensure
    MarketingMario::Tools::TemplateManager.define_singleton_method(:global_dir) { old }
  end

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

  def capture_stderr
    old_stderr = $stderr
    $stderr = StringIO.new
    yield
  rescue SystemExit
  ensure
    result = $stderr.string
    $stderr = old_stderr
    return result
  end
end
