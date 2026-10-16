# Lightweight Java 17 JRE (Alpine)
FROM eclipse-temurin:17-jre-alpine

# Set port number
EXPOSE 8090

# Set the working directory in the container
WORKDIR /app

# Copy the packaged JAR file into the container
COPY target/jenkins-demo.jar app.jar

# Specify the command to run on container startup
CMD ["java", "-jar", "app.jar"]
