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
    	String remoteAddress = request.getRemoteAddr();
    	
    	if (!("127.0.0.1".equals(remoteAddress) || "0:0:0:0:0:0:0:1".equals(remoteAddress))) {
    		final String forbiddenMessage = "Calling the metrics endpoint from " + remoteAddress + " is not allowed";
    		
    		throw new WebApplicationException(Response.status(Status.FORBIDDEN).entity(forbiddenMessage).build());
    	}
    	
        final StreamingOutput stream = output -> PrometheusExporter.instance().export(output);
        return Response.ok(stream).build();
    }

    @Override
    public void close() {
        // Nothing to do, no resources to close
    }
}
