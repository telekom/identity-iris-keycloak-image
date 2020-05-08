ARG BASE_IMAGE_TAG=9.0.0

FROM mtr.external.otc.telekomcloud.com/tif-public/keycloak:$BASE_IMAGE_TAG

LABEL maintainer="Digital Hub Enterprise Integration (DHEI)"
LABEL description="joboss/keycloak Docker image bundled with extensions selected by DHEI"

ADD providers /opt/jboss/keycloak/standalone/deployments

USER root
RUN chgrp -R 0 $JBOSS_HOME && chmod -R g+rw $JBOSS_HOME