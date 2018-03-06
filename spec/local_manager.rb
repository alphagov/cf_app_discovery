class LocalManager
  def initialize(targets_path:, folders: [])
    @targets_path = targets_path

    folders.each do |folder|
      FileUtils.mkdir_p("#{targets_path}/#{folder}")
    end
  end

  def filenames(folder)
    Dir["#{@targets_path}/#{folder}/*.json"]
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

  def remove(*paths)
    paths.each do |path|
      FileUtils.rm("#{@targets_path}/#{path}", force: true)
    end
  end

  def move(old_filename, new_filename)
    FileUtils.mv("#{@targets_path}/#{old_filename}", "#{@targets_path}/#{new_filename}")
  end
end
