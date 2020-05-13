# tif-keycloak Docker Image

Keycloak image provided by DHEI that comes with selected extensions like a prometheus metrics exporter.  
This image is meant to be used only with the Keycloak Helm chart provided by DHEI: [/tif/infra/charts/keycloak](https://ceiser-wbench.psst.t-online.corp/gitlab/tif/infra/charts/keycloak)

## Extensions

### keycloak-metrics-spi

If you deploy the Keycloak by using this image, it will make a new REST endpoint available: ``https://my-keycloak-instance/auth/realms/master/metrics``.  
From this endpoint you will be able to access all metrics from all(!) relams no matter what realm is in the url.

Important:  This image is meant to be used only with the Keycloak Helm chart provided by DHEI, since it will provide enhanced security configuration, so that the metrics won't be exposed to everyone.  
If you use this image with the Keycloak Helm chart provided by DHEI you will get the HTTP status ``401 Unauthorized`` if you try to call the new metrics endpoint. Apart from that ou will get the following response message:  
> No or invalid authentication token has been provided.  

This is very much expected, since we want to access the metrics endpoint in a more secure manner. You will need to set an authentication header with your request, like so:

```
curl -H "X-Metrics-Auth-Token:superuser" https://my-keycloak-instance/auth/realms/master/metrics
```

After deploying the Keycloak Helm chart there will also be a new Kubernetes service ``keycloak-metrics`` that is properly annotated so that Prometheus will find it. By calling this service it will actually call a reverse proxy that has been configured by the Keycloak Helm chart which is pointing to the secured metrics endpoint and will automatically set the authentication header for you (which also can be configured in the Helm chart).  

Of course you can call this service internally within the cluster (and cluster-wide) like so:
``http://keycloak-metrics.<namespace>:9542/metrics``

 
