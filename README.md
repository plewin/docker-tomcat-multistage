# docker-tomcat-multistage

Dockerfile multistage of tomcat 8 running on java 8

## Build image
docker build -t tomcat-multistage .

## Test image
docker run -d -p 8080:8080 tomcat-multistage