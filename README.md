# Java Application Deployment Using Docker Multi-Stage Build

## Project Description

This project explains how to build and deploy a Java web application using Maven, Docker, and Apache Tomcat.

Docker Multi-Stage Build is used to build the application in one stage and deploy it in another stage.

In the first stage, Amazon Linux is used to install Java 17 and Maven. Maven builds the application and generates a WAR file.

In the second stage, the WAR file is copied into the Tomcat server and deployed.

## Tools and Technologies

- Amazon Linux
- Java 17
- Maven
- Docker
- Docker Multi-Stage Build
- Apache Tomcat 9

## Project Workflow

1. Start with the Amazon Linux base image.
2. Install Java 17 and Maven.
3. Copy the application source code into the container.
4. Run `mvn clean install` to build the application.
5. Generate the WAR file inside the target folder.
6. Start the second stage using the Tomcat 9 image.
7. Copy the WAR file from the build stage to the Tomcat webapps folder.
8. Rename the WAR file to `ROOT.war`.
9. Start the Tomcat server on port 8080.

## Dockerfile Explanation

### Stage 1: Build Stage

```dockerfile
FROM amazonlinux:latest AS buildstage

RUN yum install java-17-amazon-corretto-devel maven -y

WORKDIR /opt/Docker_Project

COPY . .

RUN mvn clean install
```

- Downloads the Amazon Linux image.
- Installs Java 17 and Maven.
- Creates a working directory.
- Copies project files into the container.
- Builds the Java application using Maven.

### Stage 2: Deployment Stage

```dockerfile
FROM tomcat:9.0

WORKDIR /usr/local/tomcat/webapps

COPY --from=buildstage /opt/Docker_Project/target/*.war .

RUN rm -rf ROOT && mv *.war ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

- Uses the Tomcat 9 image.
- Sets the Tomcat webapps directory.
- Copies the WAR file from the first stage.
- Renames the WAR file to ROOT.war.
- Exposes port 8080.
- Starts the Tomcat server.

## Docker Commands

### 1. Build Docker Image

```bash
docker build -t dockerproject:v1 .
```

### 2. Check Docker Images

```bash
docker images
```

### 3. Run Docker Container

```bash
docker run -d --name myapp -p 8080:8080 dockerproject:v1
```

### 4. Check Running Containers

```bash
docker ps
```

### 5. Check Container Logs

```bash
docker logs myapp
```

### 6. Access Application

Open your browser and enter:

```text
http://<EC2-PUBLIC-IP>:8080
```

For local testing:

```text
http://localhost:8080
```

### 7. Stop Container

```bash
docker stop myapp
```

### 8. Remove Container

```bash
docker rm myapp
```

## Advantages of Multi-Stage Build

- Reduces the final Docker image size by excluding build tools.
- Separates the build environment from the runtime environment.
- Keeps the final image simple.
- Makes application deployment easier.
- Helps in creating optimized Docker images.

## Expected Output

After successfully running the container, the Tomcat server starts on port 8080 and the Java web application becomes accessible through a browser.

## Conclusion

In this project, I learned how to use Docker Multi-Stage Builds to build a Java application using Maven and deploy the generated WAR file into an Apache Tomcat server.
