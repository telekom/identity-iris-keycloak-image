# Iris Docker Image

Iris image provided by DHEI and based on Keycloak that comes with selected extensions like a prometheus metrics exporter.  
This image is meant to be used only with the Iris Helm chart provided by DHEI: [/tif/infra/charts/iris](https://ceiser-wbench.psst.t-online.corp/gitlab/tif/infra/charts/iris)

## Extensions

### keycloak-metrics-spi

If you deploy the Keycloak by using this image, it will make a new REST endpoint available: ``https://my-keycloak-instance/auth/realms/master/metrics``.  
From this endpoint you will be able to access all metrics from all(!) realms no matter what realm is in the url.

After deploying the Iris Helm chart this path won't be available because it isn't secured by a password and therefore blocked by ha-proxy. 
To provide the metrics to the monitoring infrastructure ha-proxy forwards requests from :9542/metrics to Keycloaks metrics.
 
