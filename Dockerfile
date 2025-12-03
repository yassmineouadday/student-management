# Étape 1 : Build avec Maven
FROM maven:3.9.1-openjdk-17-slim AS build
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier le reste du code et compiler
COPY src ./src
RUN mvn clean package -DskipTests

# Étape 2 : Image runtime
FROM openjdk:17-slim
WORKDIR /app

# Copier le jar compilé depuis l'étape de build
COPY --from=build /app/target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Commande par défaut
ENTRYPOINT ["java","-jar","app.jar"]


