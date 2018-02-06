require "spec_helper"

RSpec.describe CfAppDiscovery::Cleaner do
  subject { described_class.new(targets_path: targets_path) }

  let(:targets_path) { Dir.mktmpdir }
  let(:guid) { "00000000-0000-0000-0000-000000000001" }
  let(:old_guid) { "00000000-0000-0000-0000-000000000000" }
  let(:current_target) do
    CfAppDiscovery::Parser::Target.new(guid: guid, name: "foo", instances: 1, state: "", env: {})
  end

  it "removes configuration files for old targets when no current targets exist" do
    filename = "#{targets_path}/#{guid}.json"
    FileUtils.touch(filename)

    expect { subject.remove_old_targets([]) }
      .to change { File.exist?(filename) }
      .from(true)
      .to(false)
  end

  it "removes configuration files for old targets" do
    old_target_filename = "#{targets_path}/#{old_guid}.json"
    current_target_filename = "#{targets_path}/#{guid}.json"
    FileUtils.touch(old_target_filename)
    FileUtils.touch(current_target_filename)

    expect { subject.remove_old_targets([current_target]) }
      .to change { File.exist?(old_target_filename) }
      .from(true)
      .to(false)
    expect(File.exist?(current_target_filename)).to eq(true)
  end
end
