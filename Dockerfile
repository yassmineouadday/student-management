
# STEP 1 : MAVEN BUILD WITH CACHE
FROM maven:3.8.5-openjdk-17 AS build WORKDIR /app
# Copy only pom.xml first for dependency caching COPY pom.xml .
RUN mvn dependency:go-offline -B
# Copy project source
COPY SCC ./s.cc
RUN mvn package -DskipTests -B
# STEP 2: RUNTIME IMAGE
FROM eclipse-temurin:17-jdk WORKDIR /app
COPY -from-build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]|


