# ===== STAGE 1: Build with Maven (JDK 25) =====
FROM maven:3.9.11-eclipse-temurin-25 AS build

WORKDIR /app

# Cache deps
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Build
COPY src ./src
RUN mvn -B clean package -DskipTests

# ===== STAGE 2: Run (JRE 25) =====
FROM eclipse-temurin:25-jre

WORKDIR /app
COPY --from=build /app/target/*jar /app/app.jar

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
