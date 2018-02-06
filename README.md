## cf_app_discovery

Discover apps using the Cloud Foundry API and write a Prometheus targets config.

### Overview

Tool for application discovery in the [PaaS](https://docs.cloud.service.gov.uk) platform to allow dynamic creation of target files for Prometheus metrics re-collection.

### Detail

The tools use the PaaS Cloud Foundry API to discover running apps in the platform.

Once the list of available apps has been obtained, it filters out "STOPPED" applications or applications not configured to work with Prometheus.

With the final list of running applications configured fro Prometheus, the corresponding target files are created to allow Prometheus to load the new targets.

#### When an application is configured for Prometheus?

To configure a PaaS application to be discovered need to have defined an environment variable with the scrapping path:
```
PROMETHEUS_METRICS_PATH: /prometheus
``` 

### Usage

```bash
$ bundle --without development

$ export API_ENDPOINT=<api_endpoint>
$ export UAA_ENDPOINT=<uaa_endpoint>
$ export UAA_USERNAME=<username>
$ export UAA_PASSWORD=<password>
$ export PAAS_DOMAIN=<paas_domain>
$ export TARGETS_PATH=<targets_folder>

$ bundle && ./cf_app_discovery
```
