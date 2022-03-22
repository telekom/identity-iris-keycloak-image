ARG BASE_IMAGE_TAG=9.0.3

FROM mtr.external.otc.telekomcloud.com/tif-public/keycloak:$BASE_IMAGE_TAG

LABEL maintainer="Digital Hub Enterprise Integration (DHEI)"
LABEL description="joboss/keycloak Docker image bundled with extensions selected by DHEI"

ADD providers /opt/jboss/keycloak/standalone/deployments
#ADD themez /opt/jboss/keycloak/standalone/deployments

USER root

# Used for OpenShift compatibility
# See: https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html
RUN chgrp -R 0 "$JBOSS_HOME" && chmod -R g=u "$JBOSS_HOME"

USER 1000
