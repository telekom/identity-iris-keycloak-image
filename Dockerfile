ARG BASE_IMAGE_TAG=20.0.1

FROM mtr.devops.telekom.de/tardis-common/keycloak:$BASE_IMAGE_TAG as builder

LABEL maintainer="Digital Hub Enterprise Integration (DHEI)"
LABEL description="Keycloak Docker image bundled with extensions selected by DHEI"

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH=/auth

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM mtr.devops.telekom.de/tardis-common/keycloak:$BASE_IMAGE_TAG
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# ADD providers /opt/jboss/keycloak/standalone/deployments
ADD providers /opt/keycloak/providers/

# ADD themez /opt/jboss/keycloak/standalone/deployments
ADD themez /opt/keycloak/themes

USER root

#Update dependencies
RUN microdnf upgrade --setopt=install_weak_deps=0

# Used for OpenShift compatibility
# See: https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html
# RUN chgrp -R 0 "$JBOSS_HOME" && chmod -R g=u "$JBOSS_HOME"

USER 1000
