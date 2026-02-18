require "test_helper"

class MarketingMarioTest < Minitest::Test
  def test_has_version_number
    refute_nil MarketingMario::VERSION
    assert_match(/\A\d+\.\d+\.\d+\z/, MarketingMario::VERSION)
  end

  def test_gem_root
    assert_equal File.expand_path("../..", __FILE__), MarketingMario.gem_root
  end

  def test_data_dir
    assert MarketingMario.data_dir.end_with?("/data")
    assert File.directory?(MarketingMario.data_dir)
  end
end
