# [1.2.0](https://github.com/telekom/identity-iris-keycloak-image/compare/1.1.2...1.2.0) (2025-11-28)


### Features

* use eclipse temurin instead openjdk ([#10](https://github.com/telekom/identity-iris-keycloak-image/issues/10)) ([c09636d](https://github.com/telekom/identity-iris-keycloak-image/commit/c09636d1fa019ddfa2b474a8a64be5736c1b9216))

<!--
SPDX-FileCopyrightText: 2025 Deutsche Telekom AG

SPDX-License-Identifier: CC0-1.0    
-->

## [1.1.2]
### Changed
- Removed `--legacy-observability-interface` option from the `Dockerfile` to align with updated Keycloak management interface practices. See: https://www.keycloak.org/server/management-interface#_disable_management_interface

---

## [1.1.1] 
### Changed
- Refactored image build process to use a unified multi-stage `Dockerfile`.
- Removed legacy `Dockerfile.multi-stage`, `.gitlab-ci.yml`, and theme support (not related to M2M).
- Updated `README.md` with instructions for local multi-stage builds and extension usage.

### Added
- New Keycloak SPI extension: `client-auth-method-spi`.
    - Tracks client authentication methods (`Basic`, `Post`, `PostBasic`) with Prometheus metrics.
    - Toggleable via `CLIENT_AUTH_METHOD_METRICS_ENABLED` environment variable.

---

## [1.1.0]
### Changed
- Updated base Keycloak version to `26.0.8`.

---

## [1.0.0]
### Initial
- Initial release of the IRIS Keycloak image.
