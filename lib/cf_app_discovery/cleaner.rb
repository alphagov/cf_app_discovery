class CfAppDiscovery
  class Cleaner
    attr_accessor :filestore_manager

    def initialize(filestore_manager:)
      self.filestore_manager = filestore_manager
    end

    def remove_old_target(target_guid)
      filestore_manager.remove("/active/#{target_guid}.json", "/inactive/#{target_guid}.json")
    end

    def move_stopped_targets(stopped_targets)
      target_files = filestore_manager.filenames('active')
      target_files.each do |filename|
        filename = filename.split('/').last
        filestore_manager.move("active/#{filename}", "inactive/#{filename}") if file_in_targets?(filename, stopped_targets)
      end
    end

  private

    def file_in_targets?(filename, current_targets)
      current_targets.any? do |target|
        filename.include?(target.guid)
      end
    end
  end
end
