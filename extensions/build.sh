#!/bin/bash

LIBS_DIR="./../providers"

function init() {
  mkdir -p "$LIBS_DIR"
}

function build_keycloak_metrics_spi_extension() {
  EXTENSION_NAME="keycloak-metrics-spi"

  KEYCLOAK_VERSION="16.1.1"
  PROMETHEUS_JAVA_SIMPLECLIENT_VERSION="0.9.0"

  pushd "$EXTENSION_NAME"
    ./gradlew -PkeycloakVersion="$KEYCLOAK_VERSION" -PprometheusVersion="$PROMETHEUS_JAVA_SIMPLECLIENT_VERSION" clean build jar

    if [ $? -ne 0 ]; then FAILED=true; fi 
  popd

  if [ -n "$FAILED" ]; then 
    echo
    echo "Error: Failed to build extension $EXTENSION_NAME"
    echo 

    exit 1
  fi

  cp -a "$EXTENSION_NAME/build/libs/." "$LIBS_DIR/"
}

init && \
build_keycloak_metrics_spi_extension
