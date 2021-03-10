package io.quarkus.benchmark.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.MeterRegistry;

@Path("/json")
public class JsonResource {
    private static final String HELLO = "Hello, World!";

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(
        value="getop.timer",
        description="Display json")
    public Message json() {
        return new Message(HELLO);
    }
}

