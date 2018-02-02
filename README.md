## cf_app_discovery

Discover apps using the Cloud Foundry API and write a Prometheus targets config.

### Overview

TODO

### Usage

```bash
$ bundle --without development

$ export API_ENDPOINT=<cloud_foundry_api>
$ export API_TOKEN=<cloud_foundry_oauth_token>
$ export TARGETS_PATH=<path_to_targets_directory>

$ bundle && ./cf_app_discovery
```
