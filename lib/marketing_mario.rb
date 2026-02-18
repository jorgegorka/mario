require_relative "marketing_mario/version"

module MarketingMario
  class Error < StandardError; end

  def self.gem_root
    File.expand_path("..", __dir__)
  end

  def self.data_dir
    File.join(gem_root, "data")
  end
end
