cf us test-flask-app-2 gds-prometheus-test
cf bind-service test-flask-app-2 gds-prometheus-test  
cf restage test-flask-app-2
cf logs prometheus-service-broker-test --recent