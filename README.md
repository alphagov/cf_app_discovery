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

### Pre-requisites

In order to deploy this on PaaS you will need to set up a [user provided service][] containing the following block of credentials:

```shell
cf cups prometheus-targets-access -p '{
  "AWS_ACCESS_KEY_ID":"<AWS ACCESS KEY ID>",
  "AWS_SECRET_ACCESS_KEY":"<AWS SECRET>",
  "UAA_PASSWORD":"<UAA PASSWORD>",
  "UAA_USERNAME":"<UAA USERNAME>"
}'
```

This block of credentials can be found in the team `reng-pass` credentials store.

### Deploying the service broker

The application has a `manifest.yml` which has cloud foundry config and can be deployed to the PaaS by running `cf push`, this should create a `prometheus-service-broker` and a `prometheus-target-updater` app.

### Developing the service broker

You will probably also want to set up a different [user provided service](#pre-requisites) so that your changes do not affect the live settings. Information to get the staging settings can be found in the `reng-pass` credentials store, if you change the name of the service from the default, make sure that the name is updated in the `manifest.yml` and `load_access`.

If you want to make changes to the service broker to you will probably want to deploy it within a test environment, to do this you will need to change the service id, service name and plan id in `manifest.yml` and the service broker and target updater names in `manifest.yml`

To generate a new guid, run `uuidgen | awk '{print tolower($0)}'`

[Deploy the service broker](#deploying-the-service-broker)

Then you will need to create the service-broker which will be limited to the space that the app was deployed to:

`cf csb <service broker name> <username> <password> https://<route to service broker>.cloudapps.digital --space-scoped`

Once testing is complete you must use the existing service and plan ids, service names and routes and then deploy the service broker with your code updates.

Remember to remove any test apps and services once testing is complete.

### Binding apps

In order to bind an app to the service broker you will to give gds-prometheus permissions to access your space

`cf set-space-role prometheus-for-paas@digital.cabinet-office.gov.uk gds-tech-ops <your space name> SpaceAuditor`

Show that the service is available in the cloud foundry marketplace:

`cf marketplace`

Next step is to create a local instance of the service:

`cf create-service <service name in marketplace> prometheus <local service name>`

Then bind the your app to the service:

`cf bind-service <app name> <local service name>`

To see the apps bound to a service:

`cf services`

[user provided service]: https://docs.cloudfoundry.org/devguide/services/user-provided.html#credentials

### Available target information

Each target has a block of information attached to it that is captured by this application.

 - targets - Route to the application

This application also exposes a number of labels for each target to help organise metrics.

 - job   - The app name, one job can have multiple instances
 - org   - A group of users, applications and environments on PaaS
 - space - This is the space within the PaaS org where the application is held

### Routes

This application will only scrape metrics on the first route, so other routes will be ignored.

If routes for an bound app are updated, the update will be picked up by the `target updater` which is run every 5 minutes, so there may be a brief break in the metrics collected.

If an app is bound that doesn't have a route or if an app that's already bound has all its routes removed prometheus will not be able to scrape it.  As a result, the `up` metric for the app will show the app to be unavailable.
