FactoryBot.define do
  factory :target, :class => CfAppDiscovery::Target do
    guid { nil }
    name { nil }
    instances { nil }
    state { nil }
    route { nil }
    space { nil }
    org { nil }
    detected_start_command { nil }

    initialize_with {
      new(
        guid:guid,
        name:name,
        instances:instances,
        state:state,
        route:route,
        space:space,
        org:org,
        detected_start_command:detected_start_command,
      )
    }
  end
end
