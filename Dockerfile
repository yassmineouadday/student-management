# Étape 1 : Builder l'application avec Maven
FROM maven:3.9.1-openjdk-20-slim AS build
WORKDIR /app

# Copier le fichier pom et le code source
COPY pom.xml .
COPY src ./src

# Build du projet (skip tests pour accélérer)
RUN mvn clean package -DskipTests

# Étape 2 : Créer l'image runtime
FROM openjdk:20-jdk-alpine
WORKDIR /app

# Copier le jar construit depuis l'étape build
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080 

# Commande pour lancer l'application
CMD ["java", "-jar", "app.jar"]
