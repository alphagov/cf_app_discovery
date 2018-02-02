module StubHelper
  def response_data
    {
      next_url: nil,
      prev_url: nil,
      resources: [
        {
          metadata: { guid: "app-1-guid" },
          entity: {
            name: "app-1",
            instances: 2,
          },
        },
        {
          metadata: { guid: "app-2-guid" },
          entity: {
            name: "app-2",
            instances: 3,
          },
        },
      ]
    }
  end

  def stub_apps_api_endpoint
    stub_request(:get, "https://example.com:80/v2/apps")
      .with(headers: { 'Authorization'=>'bearer dummy-oauth-token' })
      .to_return(body: response_data.to_json)
  end
end
