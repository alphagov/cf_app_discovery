## cf_app_discovery

A Cloud Foundry
[Service Broker](https://docs.cloudfoundry.org/services/overview.html)
that can be bound to apps on the
[GOV.UK PaaS](https://docs.cloud.service.gov.uk) so they can be discovered by
Prometheus.

## Overview

This application can be run as a Service Broker. It serves an API that is called
by the platform when apps are registered/scaled/terminated on the PaaS. This
application builds a Prometheus targets file for active targets and writes them
to an S3 bucket. The contents of this bucket can then be synchronized to a
Prometheus server
[via cron](https://github.com/alphagov/prometheus-aws-configuration/blob/master/terraform/modules/prometheus/cloud.conf#L105-L109),
or some other means.

## Forward Proxy

To fetch metrics from a specific instance of an app, you need to set the
`X-CF-APP-INSTANCE` header on outbound requests to Cloud Foundry
([docs](https://docs.cloudfoundry.org/devguide/deploy-apps/routes-domains.html#routing-requests-to-a-specific-app-instance)).
This application configures targets with a query parameter for this, so you'll
need to convert this to a header and use a forward proxy to set the header, e.g.

```
server {
  listen 8080;
  resolver 10.0.0.2;

  location / {
    proxy_pass https://$host$uri;
    proxy_ssl_server_name on;
    proxy_set_header X-CF-APP-INSTANCE $arg_cf_app_guid:$arg_cf_app_instance_index;
  }
}
```

Currently, Prometheus doesn't support setting headers (other than basic auth) on
outbound requests.

## User Agent

This application sets a custom user agent string of
`cf_app_discovery - GDS - RE` to requests to fetch the application data.

## Deployment

The application has a `manifest.yml` and can be deployed to the PaaS. You
shouldn't need to do this yourself. Instead, raise a ticket with GDS Reliability
Engineering to add the existing Service Broker to your Space.
