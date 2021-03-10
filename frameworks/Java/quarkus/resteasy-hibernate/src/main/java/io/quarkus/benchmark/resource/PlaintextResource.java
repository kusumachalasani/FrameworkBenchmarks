package io.quarkus.benchmark.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.MeterRegistry;

@Path("/plaintext")
public class PlaintextResource {
    private static final String HELLO = "Hello, World!";

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(
        value="getop.timer",
        description="Display plain text")
    public String plaintext() {
        return HELLO;
    }
}
