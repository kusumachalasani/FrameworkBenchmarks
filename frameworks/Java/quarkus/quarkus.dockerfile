FROM maven:3.6.3-jdk-11-slim as maven
WORKDIR /quarkus
ENV MODULE=resteasy-hibernate

COPY pom.xml pom.xml
COPY $MODULE/pom.xml $MODULE/pom.xml

# Uncomment to test pre-release quarkus
#RUN mkdir -p /root/.m2/repository/io
#COPY m2-quarkus /root/.m2/repository/io/quarkus

WORKDIR /quarkus/$MODULE
RUN mvn dependency:go-offline -q
WORKDIR /quarkus

COPY $MODULE/src $MODULE/src

WORKDIR /quarkus/$MODULE
RUN mvn package -q
WORKDIR /quarkus

FROM openjdk:11.0.6-jdk-slim
WORKDIR /quarkus
ENV MODULE=resteasy-hibernate

COPY --from=maven /quarkus/$MODULE/target/quarkus-app/lib lib
COPY --from=maven /quarkus/$MODULE/target/quarkus-app/quarkus quarkus
COPY --from=maven /quarkus/$MODULE/target/quarkus-app/app app
COPY --from=maven /quarkus/$MODULE/target/quarkus-app/quarkus-run.jar app.jar
#COPY --from=maven /quarkus/$MODULE/target/lib lib
#COPY --from=maven /quarkus/$MODULE/target/$MODULE-1.0-SNAPSHOT-runner.jar app.jar

EXPOSE 8080

EXPOSE 8080

ENV JAVA_OPTIONS="-server -XX:-UseBiasedLocking -XX:+UseStringDeduplication -XX:+UseNUMA -XX:+UseParallelGC -Djava.lang.Integer.IntegerCache.high=10000 -Dvertx.disableHttpHeadersValidation=true -Dvertx.disableMetrics=true -Dvertx.disableH2c=true -Dvertx.disableWebsockets=true -Dvertx.flashPolicyHandler=false -Dvertx.threadChecks=false -Dvertx.disableContextTimings=true -Dvertx.disableTCCL=true -Dhibernate.allow_update_outside_transaction=true -Djboss.threads.eqe.statistics=false"

ENTRYPOINT java ${JAVA_OPTIONS} -jar app.jar

#CMD ["java", "-server", "-XX:-UseBiasedLocking", "-XX:+UseStringDeduplication", "-XX:+UseNUMA", "-XX:+UseParallelGC", "-Djava.lang.Integer.IntegerCache.high=10000", "-Dvertx.disableHttpHeadersValidation=true", "-Dvertx.disableMetrics=true", "-Dvertx.disableH2c=true", "-Dvertx.disableWebsockets=true", "-Dvertx.flashPolicyHandler=false", "-Dvertx.threadChecks=false", "-Dvertx.disableContextTimings=true", "-Dvertx.disableTCCL=true", "-Dhibernate.allow_update_outside_transaction=true", "-Djboss.threads.eqe.statistics=false", "-jar", "app.jar"]
