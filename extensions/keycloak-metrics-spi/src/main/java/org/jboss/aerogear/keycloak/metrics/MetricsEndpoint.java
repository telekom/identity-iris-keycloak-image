package org.jboss.aerogear.keycloak.metrics;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.StreamingOutput;

import org.keycloak.services.resource.RealmResourceProvider;

public class MetricsEndpoint implements RealmResourceProvider {

    // The ID of the provider is also used as the name of the endpoint
    public final static String ID = "metrics";
    
    @Override
    public Object getResource() {
        return this;
    }

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public Response get(@Context HttpServletRequest request) {
    	final String metricsAuthToken = request.getHeader("X-Metrics-Auth-Token");
    	final String configuredMetricsAuthToken = PrometheusExporter.instance().getMetricsAuthToken();
    	
    	if (configuredMetricsAuthToken != null) {
        	if (metricsAuthToken == null || !configuredMetricsAuthToken.equals(metricsAuthToken)) {
        		final String forbiddenMessage = "No or invalid authentication token has been provided.";
        		
        		throw new WebApplicationException(Response.status(Status.UNAUTHORIZED).entity(forbiddenMessage).build());
        	}    		
    	}

        final StreamingOutput stream = output -> PrometheusExporter.instance().export(output);
        return Response.ok(stream).build();
    }

    @Override
    public void close() {
        // Nothing to do, no resources to close
    }
}
