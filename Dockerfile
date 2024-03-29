# SPDX-FileCopyrightText: 2023 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

#desired version of Keycloak
ARG BASE_IMAGE_TAG=21.1.2

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG AS builder

LABEL description="Keycloak Docker image bundled with extensions"

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_CACHE_STACK=kubernetes

# Configure a database vendor
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH=/auth

ADD providers /opt/keycloak/providers/

ADD themes /opt/keycloak/providers/

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build --cache=ispn

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG
COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER root

USER 1000
