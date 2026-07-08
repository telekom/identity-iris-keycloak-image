//SPDX-FileCopyrightText: 2023 Deutsche Telekom AG
//
//SPDX-License-Identifier: Apache-2.0

package de.telekom.keycloak.authentication.authenticators.client;

import io.micrometer.core.instrument.Counter;
import jakarta.ws.rs.core.HttpHeaders;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.MultivaluedMap;
import org.jboss.logging.Logger;
import org.keycloak.Config;
import org.keycloak.OAuth2Constants;
import org.keycloak.authentication.ClientAuthenticationFlowContext;
import org.keycloak.authentication.FlowStatus;
import org.keycloak.authentication.authenticators.client.ClientIdAndSecretAuthenticator;

/**
 * Client authenticator that reports the client authentication method used via prometheus metrics
 * Reporting can be enabled/disabled via the boolean CLIENT_AUTH_METHOD_METRICS_ENABLED environment variable
 * Delegates to the default {@link ClientIdAndSecretAuthenticator} for actual authentication
 * Should be referenced in META-INF/services/org.keycloak.authentication.ClientAuthenticatorFactory
 *
 * @see ClientIdAndSecretAuthenticator
 */
public class TracingClientIdAndSecretAuthenticator extends ClientIdAndSecretAuthenticator {
    private static final Logger logger = Logger.getLogger(TracingClientIdAndSecretAuthenticator.class);
    private static final String BASIC_METRIC_NAME = "keycloak_client_auth_method_basic_total";
    private static final String BASIC_METRIC_DESCRIPTION = "Total number of times basic client authentication method was used";
    private static final String POST_METRIC_NAME = "keycloak_client_auth_method_post_total";
    private static final String POST_METRIC_DESCRIPTION = "Total number of times post client authentication method was used";
    private static final String POSTBASIC_METRIC_NAME = "keycloak_client_auth_method_postbasic_total";
    private static final String POSTBASIC_METRIC_DESCRIPTION = "Total number of times non-standard basic/post client authentication method was used";

    private static final boolean ENABLED = Boolean.parseBoolean(System.getenv("CLIENT_AUTH_METHOD_METRICS_ENABLED"));

    @Override
    public void init(Config.Scope config) {
        logger.info("Client auth method metrics enabled: " + ENABLED);
        super.init(config);
    }

    @Override
    public void authenticateClient(ClientAuthenticationFlowContext context) {
        super.authenticateClient(context);
        if (!ENABLED) {
            return;
        }
        try {
            // Report only successful authentications
            if (FlowStatus.SUCCESS.equals(context.getStatus())) {
                final var client = context.getClient();
                final var realmName = context.getRealm().getName();
                final var requestPath = context.getUriInfo().getPath();
                final var authMethod = getAuthMethod(context);
                logger.debugf("Authenticated %s\\%s authMethod: %s path: %s", realmName, client.getClientId(), authMethod, requestPath);
                if (authMethod == null) {
                    logger.warnf("Unknown client authentication method for client %s in realm %s", client.getClientId(), realmName);
                    return;
                }
                else if (authMethod == AuthMethod.POSTBASIC) {
                    logger.debugf("Non-standard post/basic client authentication method for client %s in realm %s", client.getClientId(), realmName);
                }
                // Report auth method to micrometer metrics
                Metrics.INSTANCE.reportAuthMethod(client.getClientId(), realmName, requestPath, authMethod);
            }
        } catch (Exception e) {
            // Ignore exception, we don't want to break the authentication flow
            logger.error("Unexpected error while trying report client authentication method", e);
        }
    }

    private static AuthMethod getAuthMethod(ClientAuthenticationFlowContext context) {
        // Handling mostly copied from ClientIdAndSecretAuthenticator
        boolean authHeaderExists = context.getHttpRequest().getHttpHeaders().getRequestHeaders().getFirst(HttpHeaders.AUTHORIZATION) != null;
        final var mediaType = context.getHttpRequest().getHttpHeaders().getMediaType();
        final boolean hasFormData = mediaType != null && mediaType.isCompatible(MediaType.APPLICATION_FORM_URLENCODED_TYPE);
        final MultivaluedMap<String, String> formData = hasFormData ? context.getHttpRequest().getDecodedFormParameters() : null;
        final var clientIdExists = formData != null && formData.containsKey(OAuth2Constants.CLIENT_ID);

        if (authHeaderExists && clientIdExists) {
            return AuthMethod.POSTBASIC;
        } else if (authHeaderExists) {
            return AuthMethod.BASIC;
        } else if (clientIdExists) {
            return AuthMethod.POST;
        } else {
            // This is an unexpected case, we should always have either auth header or
            // client_id in form data
            return null;
        }
    }

    public enum AuthMethod {
        BASIC, POST, POSTBASIC
    }

    /**
     * Micrometer metrics for client authentication methods.
     */
    public enum Metrics { // NOSONAR
        INSTANCE;

        public static final String LABEL_CLIENT_ID = "client_id";
        public static final String LABEL_REALM = "realm";
        public static final String LABEL_PATH = "path";

        private Counter counter(String name, String description, String clientId, String realm, String path) {
            return Counter.builder(name)
                    .description(description)
                    .tag(LABEL_CLIENT_ID, clientId)
                    .tag(LABEL_REALM, realm)
                    .tag(LABEL_PATH, path)
                    .register(io.micrometer.core.instrument.Metrics.globalRegistry);
        }

        public void reportAuthMethod(String clientId, String realm, String path, AuthMethod method) {
            final var cnt = switch (method) {
                case BASIC -> counter(BASIC_METRIC_NAME, BASIC_METRIC_DESCRIPTION, clientId, realm, path);
                case POST -> counter(POST_METRIC_NAME, POST_METRIC_DESCRIPTION, clientId, realm, path);
                case POSTBASIC -> counter(POSTBASIC_METRIC_NAME, POSTBASIC_METRIC_DESCRIPTION, clientId, realm, path);
            };
            cnt.increment();
        }
    }
}
