require "spec_helper"

RSpec.describe CfAppDiscovery::Cleaner do
  subject(:cleaner) do
    described_class.new(
      filestore_manager: LocalManager.new(targets_path: targets_path, folders: %w(active inactive))
    )
  end

  let(:targets_path) { Dir.mktmpdir }
  let(:active_targets_path) {
    FileUtils.mkdir_p("#{targets_path}/active")
    "#{targets_path}/active"
  }
  let(:inactive_targets_path) {
    FileUtils.mkdir_p("#{targets_path}/inactive")
    "#{targets_path}/inactive"
  }
  let(:guid) { "00000000-0000-0000-0000-000000000001" }
  let(:old_guid) { "00000000-0000-0000-0000-000000000000" }
  let(:current_target) do
    CfAppDiscovery::Target.new(guid: guid, name: "foo", instances: 1, state: "", route: "", space: "", org: "", detected_start_command: "")
  end
  let(:stopped_target) do
    CfAppDiscovery::Target.new(guid: old_guid, name: "foo", instances: 1, state: "", route: "", space: "", org: "", detected_start_command: "")
  end

  it "overwrites any existing stopped target with same name" do
    configured_target_filename = "#{active_targets_path}/#{old_guid}.json"
    stopped_target_filename = "#{inactive_targets_path}/#{old_guid}.json"
    FileUtils.touch(configured_target_filename)
    FileUtils.touch(stopped_target_filename)

    expect { cleaner.move_stopped_targets([stopped_target]) }
      .to change { File.exist?(configured_target_filename) }
      .from(true)
      .to(false)
    expect(File.exist?(stopped_target_filename)).to eq(true)
  end

  it "moves stopped targets out of target dir" do
    stopped_target_filename = "#{active_targets_path}/#{old_guid}.json"
    current_target_filename = "#{active_targets_path}/#{guid}.json"
    FileUtils.touch(stopped_target_filename)
    FileUtils.touch(current_target_filename)

    expect { cleaner.move_stopped_targets([stopped_target]) }
      .to change { File.exist?(stopped_target_filename) }
      .from(true)
      .to(false)
    expect(File.exist?(current_target_filename)).to eq(true)
    expect(File.exist?("#{inactive_targets_path}/#{old_guid}.json")).to eq(true)
  end

  it "removes configured and stopped targets" do
    stopped_target_filename = "#{inactive_targets_path}/#{guid}.json"
    current_target_filename = "#{active_targets_path}/#{guid}.json"
    FileUtils.touch(stopped_target_filename)
    FileUtils.touch(current_target_filename)

    cleaner.remove_old_target(current_target.guid)

    expect(File.exist?(stopped_target_filename)).to eq(false)
    expect(File.exist?(current_target_filename)).to eq(false)
  end
end
