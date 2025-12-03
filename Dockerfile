# STEP 1 : MAVEN BUILD
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copier pom.xml pour le cache des dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le code source
COPY src ./src

# Compiler le projet et créer le jar
RUN mvn package -DskipTests -B

# STEP 2 : RUNTIME IMAGE
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copier le jar depuis l'image de build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]



