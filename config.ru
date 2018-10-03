$LOAD_PATH.unshift('lib')

require 'rack'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

require 'cf_app_discovery'

use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run CfAppDiscovery::ServiceBroker
