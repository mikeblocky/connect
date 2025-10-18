# ===== STAGE 1: Build with Maven =====
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests


# ===== STAGE 2: Run the built JAR =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# copy all jars then rename the final one
COPY --from=build /app/target/*.jar /app/
RUN mv /app/app.jar /app/app-run.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/app-run.jar"]
