require "spec_helper"

RSpec.describe CfAppDiscovery::TargetConfiguration do
  include StubHelper

  subject(:target_configuration) do
    described_class.new(
      filestore_manager: LocalManager.new(targets_path: targets_path),
    )
  end

  let(:targets_path) do
    path = Dir.mktmpdir

    FileUtils.mkdir_p("#{path}/active")
    FileUtils.mkdir_p("#{path}/inactive")

    path
  end

  context "for normal apps" do
    let(:targets) do
      [
        CfAppDiscovery::Target.new(
          guid: "app-1-v2-guid",
          name: "app-1",
          instances: 2,
          state: "STARTED",
          detected_start_command: nil,
          route: "route-1.example.com",
          space: "test-space-name",
          org: "test-org-name",
        ),
        CfAppDiscovery::Target.new(
          guid: "app-2-guid",
          name: "app-2",
          instances: 1,
          state: "STARTED",
          detected_start_command: nil,
          route: "route-2.custom.com",
          space: "test-space-name",
          org: "test-org-name",
        ),
      ]
    end

    it "writes files named after the target guids" do
      target_configuration.write_active_targets(targets)

      listing = Dir["#{targets_path}/active/*.json"]
      names = listing.map { |s| File.basename(s) }

      expect(names).to contain_exactly('app-1-v2-guid.json', 'app-2-guid.json')
    end

    it "writes an entry per instance for each target" do
      target_configuration.write_active_targets(targets)

      listing = Dir["#{targets_path}/active/*.json"]
      contents = listing.map { |path| File.read(path) }

      parsed = contents.collect { |item| JSON.parse(item, symbolize_names: true) }
      expect(parsed).to contain_exactly(
        [
          {
            targets: ["route-1.example.com"],
            labels: {
              __param_cf_app_guid: "app-1-v2-guid",
              __param_cf_app_instance_index: "0",
              cf_app_instance: "0",
              instance: "app-1-v2-guid:0",
              job: "app-1",
              space: "test-space-name",
              org: "test-org-name",
            },
          },
          {
            targets: ["route-1.example.com"],
            labels: {
              __param_cf_app_guid: "app-1-v2-guid",
              __param_cf_app_instance_index: "1",
              cf_app_instance: "1",
              instance: "app-1-v2-guid:1",
              job: "app-1",
              space: "test-space-name",
              org: "test-org-name",
            },
          },
        ],
        [
          {
            targets: ["route-2.custom.com"],
            labels: {
              __param_cf_app_guid: "app-2-guid",
              __param_cf_app_instance_index: "0",
              cf_app_instance: "0",
              instance: "app-2-guid:0",
              job: "app-2",
              space: "test-space-name",
              org: "test-org-name",
            },
          },
        ]
      )
    end

    context "when the target files already exist" do
      before do
        target_configuration.write_active_targets(targets)
        @first, @second = Dir["#{targets_path}/active/*.json"]

        File.open(@first, "w") { |f| f.write("this content is out of date") }

        FileUtils.touch(@first, mtime: 0)
        FileUtils.touch(@second, mtime: 0)
      end

      it "only writes files that have changed" do
        target_configuration.write_active_targets(targets)

        expect(File.mtime(@first).to_i).not_to eq(0), "File should have been written"
        expect(File.mtime(@second).to_i).to eq(0), "File should not have been written"
      end

      it "lists the apps which have been configured" do
        target_configuration.write_active_targets(targets)

        configured_apps = target_configuration.configured_apps
        expect(configured_apps.to_set).to contain_exactly('app-1-v2-guid', 'app-2-guid')
      end
    end
  end

  context "for paas-metric-exporter" do
    let(:targets) do
      [
        CfAppDiscovery::Target.new(
          guid: "app-1-v1-guid",
          name: "app-1-venerable",
          instances: 2,
          state: "STARTED",
          detected_start_command: "./bin/paas-metric-exporter",
          route: "route-1.example.com",
          space: "test-space-name",
          org: "test-org-name",
        ),
      ]
    end

    it "writes an entry per instance for each target, without the space label" do
      target_configuration.write_active_targets(targets)

      listing = Dir["#{targets_path}/active/*.json"]
      contents = listing.map { |path| File.read(path) }

      parsed = contents.collect { |item| JSON.parse(item, symbolize_names: true) }
      expect(parsed).to contain_exactly(
        [
          {
            targets: ["route-1.example.com"],
            labels: {
              __param_cf_app_guid: "app-1-v1-guid",
              __param_cf_app_instance_index: "0",
              cf_app_instance: "0",
              instance: "app-1-v1-guid:0",
              job: "app-1",
              org: "test-org-name",
            },
          },
          {
            targets: ["route-1.example.com"],
            labels: {
              __param_cf_app_guid: "app-1-v1-guid",
              __param_cf_app_instance_index: "1",
              cf_app_instance: "1",
              instance: "app-1-v1-guid:1",
              job: "app-1",
              org: "test-org-name",
            },
          },
        ]
      )
    end
  end
end
