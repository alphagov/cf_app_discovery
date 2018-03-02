class CfAppDiscovery
  class Cleaner
    attr_accessor :targets_path

    def initialize(targets_path:)
      self.targets_path = targets_path
    end

    def remove_old_target(target_guid)
      target_filename = "#{targets_path}/#{target_guid}.json"
      FileUtils.rm(target_filename, force: true)
      stopped_target_filename = "#{stopped_targets_path}/#{target_guid}.json"
      FileUtils.rm(stopped_target_filename, force: true)
    end

    def move_stopped_targets(stopped_targets)
      target_files = Dir["#{targets_path}/*.json"]
      target_files.each do |filename|
        FileUtils.mv(filename, stopped_targets_path) if file_in_targets?(filename, stopped_targets)
      end
    end

  private

    def file_in_targets?(filename, current_targets)
      current_targets.any? do |target|
        filename.include?(target.guid)
      end
    end

    def stopped_targets_path
      path = "#{targets_path}/stopped"
      FileUtils.mkdir(path) unless Dir.exist?(path)
      path
    end
  end
end
