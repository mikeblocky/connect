# ===== STAGE 1: Build with Maven =====
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml first and pre-download dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Now copy the rest of the sources and build
COPY src ./src
RUN mvn -B clean package -DskipTests


# ===== STAGE 2: Run the built JAR =====
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from previous stage
COPY --from=build /app/target/*jar /app/app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
