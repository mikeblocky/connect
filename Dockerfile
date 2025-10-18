# ===== STAGE 1: Build with Maven (JDK 25) =====
FROM maven:3.9.11-eclipse-temurin-25 AS build
WORKDIR /app

# Prove the compiler is 25 (helps debug)
RUN javac -version && java -version

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

# ===== STAGE 2: Run (JRE 25) =====
FROM eclipse-temurin:25-jre
WORKDIR /app

# target has multiple jars; copy then rename to a stable name
COPY --from=build /app/target/*.jar /app/
RUN mv /app/*.jar /app/app.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
