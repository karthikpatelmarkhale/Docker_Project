
# Stage 1: Build application using Maven
FROM amazonlinux:latest AS buildstage

RUN yum install java-17-amazon-corretto-devel maven -y

WORKDIR /opt/Docker_Project

COPY . .

RUN mvn clean install

# Stage 2: Deploy WAR into Tomcat
FROM tomcat:9.0

WORKDIR /usr/local/tomcat/webapps

COPY --from=buildstage /opt/Docker_Project/target/*.war .

RUN rm -rf ROOT && mv *.war ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
