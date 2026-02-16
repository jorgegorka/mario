require "test_helper"

class AriadnaTest < Minitest::Test
  def test_has_version_number
    refute_nil Mario::VERSION
    assert_match(/\A\d+\.\d+\.\d+\z/, Mario::VERSION)
  end

  def test_gem_root
    assert_equal File.expand_path("../..", __FILE__), Mario.gem_root
  end

  def test_data_dir
    assert Mario.data_dir.end_with?("/data")
    assert File.directory?(Mario.data_dir)
  end
end
