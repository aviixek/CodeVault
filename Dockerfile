# =======================================================
# Stage 1: Build Stage (Maven + OpenJDK 21)
# =======================================================
FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build

# Cache dependencies first
COPY pom.xml .
RUN mvn dependency:go-offline -B -q

# Copy source code and build WAR artifact
COPY src ./src
RUN mvn clean package -DskipTests -q

# =======================================================
# Stage 2: Runtime Stage (Apache Tomcat 11 + JRE 21)
# =======================================================
FROM tomcat:11.0-jdk21-temurin-noble

LABEL maintainer="CodeVault Team"
LABEL description="CodeVault — Modern, Dockerized, Security-Hardened Java Web Application"

# Remove default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/* \
    && rm -rf /usr/local/tomcat/webapps.dist

# Copy the built WAR as ROOT.war so application is served at http://localhost:8080/
COPY --from=builder /build/target/codevault.war /usr/local/tomcat/webapps/ROOT.war

# Create a dedicated non-root user and group
RUN groupadd -g 1001 tomcatgroup \
    && useradd -u 1001 -g tomcatgroup -s /bin/false -d /usr/local/tomcat tomcatuser \
    && chown -R tomcatuser:tomcatgroup /usr/local/tomcat \
    && chmod -R u+rwX,g+rX,o-rwx /usr/local/tomcat

# Run container as non-root user
USER 1001:1001

EXPOSE 8080

CMD ["catalina.sh", "run"]
