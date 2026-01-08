# -------- BUILD STAGE --------
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /trail

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build WAR file
RUN mvn clean package


# -------- RUNTIME STAGE --------
FROM tomcat:9.0-jre17

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR into Tomcat
COPY --from=build /trail/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080
