# ===== STAGE 1: Build with Maven (JDK 25) =====
FROM maven:3.9.11-eclipse-temurin-25 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

# ===== STAGE 2: Runtime (JRE 25) =====
FROM eclipse-temurin:25-jre
WORKDIR /app

# Copy the ONE jar you want to run (you have app.jar and original-app.jar)
COPY --from=build /app/target/app.jar /app/app.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
