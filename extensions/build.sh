#!/bin/bash

# SPDX-FileCopyrightText: 2025 Deutsche Telekom AG
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

declare -r LIBS_DIR="./../providers"

declare -r KEYCLOAK_VERSION="$1"
declare -r EXTENSIONS="$2"

if [ -z "$KEYCLOAK_VERSION"  ]; then
  echo "Keycloak version not specified"
  exit 1
fi

function init() {
  mkdir -p "$LIBS_DIR"
}

function build_keycloak_extension() {
  EXTENSION_NAME="$1"

  echo "Building $EXTENSION_NAME for Keycloak version $KEYCLOAK_VERSION"
  ./$EXTENSION_NAME/gradlew clean build --daemon -p ./$EXTENSION_NAME -PkeycloakVersion="$KEYCLOAK_VERSION" &&  \
    cp -a "$EXTENSION_NAME/build/libs/." "$LIBS_DIR/" && \
    return 0

  echo "Error: Failed to build extension $EXTENSION_NAME"
  exit 1
}

init && \
for ext in ${EXTENSIONS//,/ }; do
  build_keycloak_extension "${ext}"
done
