# SPDX-FileCopyrightText: 2025 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

# Keycloak version set in gitlab-ci
ARG BASE_IMAGE_TAG

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG AS builder

LABEL description="Keycloak Docker image bundled with extensions"

ADD providers /opt/keycloak/providers/

WORKDIR /opt/keycloak

# Enable health and metrics support
# Enable legacy observability interface
# Configure HTTP relative path
# Use postgres as database

RUN /opt/keycloak/bin/kc.sh build --db=postgres --http-relative-path=/auth --metrics-enabled=true --health-enabled=true --legacy-observability-interface=true --features-disabled=persistent-user-sessions

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG
COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER root

USER 1000
