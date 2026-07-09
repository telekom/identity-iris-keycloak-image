<!--
SPDX-FileCopyrightText: 2025 Deutsche Telekom AG

SPDX-License-Identifier: CC0-1.0    
-->

## [1.5.2](https://github.com/telekom/identity-iris-keycloak-image/compare/1.5.1...1.5.2) (2026-07-09)


### Bug Fixes

* **ci:** use static build revision ([#22](https://github.com/telekom/identity-iris-keycloak-image/issues/22)) ([450ba94](https://github.com/telekom/identity-iris-keycloak-image/commit/450ba947c7e11d180dbcc79c0831bff19c866258))

## [1.5.1](https://github.com/telekom/identity-iris-keycloak-image/compare/1.5.0...1.5.1) (2026-07-08)


### Bug Fixes

* expose client-auth-method-spi metrics over mgmt port ([#21](https://github.com/telekom/identity-iris-keycloak-image/issues/21)) ([a53d8ed](https://github.com/telekom/identity-iris-keycloak-image/commit/a53d8ede039adb0703e0745d5dbc2c80bed0dc5c))

# [1.5.0](https://github.com/telekom/identity-iris-keycloak-image/compare/1.4.1...1.5.0) (2026-05-04)


### Features

* do extensions as optional ([#20](https://github.com/telekom/identity-iris-keycloak-image/issues/20)) ([3c298b6](https://github.com/telekom/identity-iris-keycloak-image/commit/3c298b69be16946b677cb4a7ffe9c90b6b7e65eb))
* enable user event metrics ([#19](https://github.com/telekom/identity-iris-keycloak-image/issues/19)) ([a6709e0](https://github.com/telekom/identity-iris-keycloak-image/commit/a6709e06d3fbad45f9d34e4c057589b0fe95da53))
* optimize features ([#18](https://github.com/telekom/identity-iris-keycloak-image/issues/18)) ([fd7f8ae](https://github.com/telekom/identity-iris-keycloak-image/commit/fd7f8aeeab5368a10191c26cd9b9c5b0f6be3330))

## [1.4.1](https://github.com/telekom/identity-iris-keycloak-image/compare/1.4.0...1.4.1) (2026-04-14)


### Bug Fixes

* upgrade keycloak to 26.5.7 ([#17](https://github.com/telekom/identity-iris-keycloak-image/issues/17)) ([033e15f](https://github.com/telekom/identity-iris-keycloak-image/commit/033e15fba4fae71bc7717349a06f17bc1284cf23))

# [1.4.0](https://github.com/telekom/identity-iris-keycloak-image/compare/1.3.0...1.4.0) (2026-04-02)


### Features

* upgrade github actions ([#16](https://github.com/telekom/identity-iris-keycloak-image/issues/16)) ([fda0992](https://github.com/telekom/identity-iris-keycloak-image/commit/fda0992aa93c6985648b6cd8952bff72806e65d0))
* upgrade keycloak to v26.5.6 ([#15](https://github.com/telekom/identity-iris-keycloak-image/issues/15)) ([21622ba](https://github.com/telekom/identity-iris-keycloak-image/commit/21622bad5bf922de57cc0f697385eca7b5e4e474))

# [1.3.0](https://github.com/telekom/identity-iris-keycloak-image/compare/1.2.0...1.3.0) (2025-12-08)


### Bug Fixes

* remove helm plugin from release workflow ([b7f68ba](https://github.com/telekom/identity-iris-keycloak-image/commit/b7f68baa28b7653824f52a53b8916fa44f08c414))


### Features

* support graceful client secret rotation ([ba834aa](https://github.com/telekom/identity-iris-keycloak-image/commit/ba834aa2ac8d8488f21baa79e29e8bd2795444ed))
* support graceful secret rotation ([1035a30](https://github.com/telekom/identity-iris-keycloak-image/commit/1035a306555d4ec56ad74f1e43b2f8bee3d66fa9))

# [1.2.0](https://github.com/telekom/identity-iris-keycloak-image/compare/1.1.2...1.2.0) (2025-11-28)


### Features

* use eclipse temurin instead openjdk ([#10](https://github.com/telekom/identity-iris-keycloak-image/issues/10)) ([c09636d](https://github.com/telekom/identity-iris-keycloak-image/commit/c09636d1fa019ddfa2b474a8a64be5736c1b9216))

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
