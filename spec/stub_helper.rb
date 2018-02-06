module StubHelper
  def stub_endpoint(endpoint)
    stub_request(endpoint.http_method, endpoint.url)
      .with(
        body: endpoint.request_body,
        headers: endpoint.request_headers,
      )
      .to_return(
        body: endpoint.response_body.to_json,
        headers: endpoint.response_headers,
      )
  end
end
