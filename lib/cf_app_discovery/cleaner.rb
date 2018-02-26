class CfAppDiscovery
  class Cleaner
    attr_accessor :targets_path

    def initialize(targets_path:)
      self.targets_path = targets_path
    end

    def remove_old_targets(current_targets)
      target_files = Dir["#{targets_path}/*.json"]
      target_files.each do |filename|
        FileUtils.rm(filename) unless current_target?(filename, current_targets)
      end
    end

    def remove_old_target(target_guid)
      filename = "#{targets_path}/#{target_guid}.json"
      FileUtils.rm(filename, force: true)
    end

  private

    def current_target?(filename, current_targets)
      current_targets.any? do |target|
        filename.include?(target.guid)
      end
    end
  end
end
