class LocalManager

  def initialize(targets_path:)
    @targets_path = targets_path
  end

  def filenames(path:)
    Dir["#{@targets_path}#{path}/*.json"]
  end

  def exist?(path)
    File.exist?("#{@targets_path}/#{path}")
  end

  def read(path)
    File.read("#{@targets_path}/#{path}")
  end

  def write(content, path)
    File.open("#{@targets_path}/#{path}", "w") { |f| f.write(content) }
  end
end