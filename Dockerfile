# SPDX-FileCopyrightText: 2025 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

# Keycloak version set in gitlab-ci
ARG BASE_IMAGE_TAG=26.0.8

FROM eclipse-temurin:21.0.9_10-jdk-alpine-3.22 AS extensionbuilder

# Need to declare it again here, so we can pass it to build.sh
ARG BASE_IMAGE_TAG

RUN apk add --no-cache bash && \
    mkdir -p /app/providers

ADD extensions /app/extensions/
WORKDIR /app/extensions

RUN ./build.sh $BASE_IMAGE_TAG

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG AS builder

LABEL description="Keycloak Docker image bundled with extensions"

COPY --from=extensionbuilder /app/providers/ /opt/keycloak/providers/

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build \
    --db=postgres \
    --http-relative-path=/auth \
    --metrics-enabled=true \
    --health-enabled=true \
    --features=client-secret-rotation \
    --features-disabled=persistent-user-sessions

FROM quay.io/keycloak/keycloak:$BASE_IMAGE_TAG


COPY --from=builder /opt/keycloak/ /opt/keycloak/

USER 1000

