# Set the base image for the builder stage
FROM maven:3.8.4-openjdk-17 AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven configuration file
COPY pom.xml .

# Copy the Maven settings file if needed
# COPY settings.xml .

# Download the Maven dependencies
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src

# Set the PORT environment variable
ENV PORT=8088

# Expose the port
EXPOSE $PORT

# Build the application
RUN mvn install

# Set the base image for the final stage
FROM openjdk:17-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/*.jar /app/app.jar


# Run the application
CMD ["java", "-jar", "app.jar"]
