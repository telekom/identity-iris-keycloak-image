# Iris Docker Image

Target Repo https://mtr.devops.telekom.de/repository/tardis-internal/io/iris

## Original Keycloak Image
Mirror of original Keycloak image from quay.io/keycloak/ to https://mtr.devops.telekom.de/repository/tardis-common/keycloak.
For the mirroring Process we use: 
- specify version in template https://gitlab.devops.telekom.de/dhei/teams/io/templates/gitlab-pipelines/-/blob/develop/docker/gitlab-ci.docker.yml#L502
- start Job manual to mirror the image https://gitlab.devops.telekom.de/dhei/teams/io/tools/image-migrator/-/blob/main/.gitlab-ci.yml#L63

## Chart 
Iris image provided by DHEI and based on Keycloak that comes with selected extensions like a prometheus metrics exporter.  
This image is meant to be used only with the Iris Helm chart provided by DHEI: [/io/products/iris/iris-chart/](https://gitlab.devops.telekom.de/dhei/teams/io/products/iris/iris-chart)

## Extensions

### keycloak-metrics-spi

If you deploy the Keycloak by using this image, it will make a new REST endpoint available: ``https://my-keycloak-instance/auth/realms/master/metrics``.  
From this endpoint you will be able to access all metrics from all(!) realms no matter what realm is in the url.

After deploying the Iris Helm chart this path won't be available because it isn't secured by a password and therefore blocked by ha-proxy. 
To provide the metrics to the monitoring infrastructure ha-proxy forwards requests from :9542/metrics to Keycloaks metrics.

[ha-proxy config](https://gitlab.devops.telekom.de/dhei/teams/io/products/iris/iris-chart/-/blob/develop/templates/configmap-haproxy.yaml)
 
 ![Keycloak Prometheus Integration](img/Keycloak-Prometheus.png "Keycloak Prometheus Integration")

 # Run local development

Follow these steps to run an on-the-fly development Keycloak on your local machine: [original documentation](https://www.keycloak.org/getting-started/getting-started-zip)
1. Download Keycloak server binaries here: https://www.keycloak.org/downloads
2. Unzip to desired location
3. Copy ```enilogin``` theme and ```META-INF``` directory from Iris-Image repo to the unzipped Keycloak/themes.

![Themes placement](img/themes_dev_mode.JPG)

4. Run development mode with ```kc.sh start-dev``` or ```kc.bat start-dev```
5. Setup a realm using ENI-Login theme. You may also add an identiy provider redirecting to the master realm.
