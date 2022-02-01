FROM maven:3-jdk-11-slim AS builder
ARG ELK_VERSION=0.7.1

WORKDIR app
COPY pom.xml .

RUN mvn -Delk.version=$ELK_VERSION install

COPY --from=plantuml/plantuml-server:jetty /var/lib/jetty/webapps/ROOT.war /app/ROOT.war
RUN jar -uvf ROOT.war WEB-INF/lib/elk-full.jar

# Make result image
FROM plantuml/plantuml-server:jetty as plantuml
COPY --from=builder /app/ROOT.war /var/lib/jetty/webapps/ROOT.war
