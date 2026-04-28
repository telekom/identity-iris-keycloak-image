# SPDX-FileCopyrightText: 2025 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

# Keycloak version set in gitlab-ci
ARG BASE_IMAGE_TAG=26.5.7

FROM eclipse-temurin:21.0.10_7-jdk-alpine-3.23 AS extensionbuilder

# Need to declare it again here, so we can pass it to build.sh
ARG BASE_IMAGE_TAG
ARG EXTENSIONS="client-auth-method-spi,keycloak-metrics-spi"

RUN apk add --no-cache bash && \
    mkdir -p /app/providers

ADD extensions /app/extensions/
WORKDIR /app/extensions

RUN ./build.sh "${BASE_IMAGE_TAG}" "${EXTENSIONS}"

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG AS builder

LABEL description="Keycloak Docker image bundled with extensions"

COPY --from=extensionbuilder /app/providers/ /opt/keycloak/providers/

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build \
    --db=postgres \
    --http-relative-path=/auth \
    --metrics-enabled=true \
    --health-enabled=true \
    --features=client-secret-rotation,http-optimized-serializers \
    --feature-account-api=disabled \
    --feature-account=disabled \
    --feature-admin-fine-grained-authz=disabled \
    --feature-authorization=disabled \
    --feature-ciba=disabled \
    --feature-client-auth-federated=disabled \
    --feature-device-flow=disabled \
    --feature-dpop=disabled \
    --feature-impersonation=disabled \
    --feature-kerberos=disabled \
    --feature-log-mdc=disabled \
    --feature-opentelemetry=disabled \
    --feature-organization=disabled \
    --feature-par=disabled \
    --feature-passkeys=disabled \
    --feature-persistent-user-sessions=disabled \
    --feature-recovery-codes=disabled \
    --feature-step-up-authentication=disabled \
    --feature-token-exchange-standard=disabled \
    --feature-update-email=disabled \
    --feature-web-authn=disabled \
    --feature-workflows=disabled

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG


COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER 1000
