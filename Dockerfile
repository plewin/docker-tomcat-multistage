# Stage 1: Build tomcat with ant
# ==============================
FROM herveleclerc/docker-alpine-java8-jdk:latest as builder
LABEL maintainer "philippe.lewin@gmail.com"

ENV TOMCAT_TBZ_URL https://www.apache.org/dist/ant/binaries/apache-ant-1.10.1-bin.tar.bz2
ENV ANT_TGZ_URL http://apache.mirrors.ovh.net/ftp.apache.org/dist/tomcat/tomcat-8/v8.5.15/src/apache-tomcat-8.5.15-src.tar.gz

WORKDIR /tmp/

# Download and decompress
RUN curl -Ls $TOMCAT_TBZ_URL > apache-ant-x-bin.tar.bz2 \
    && curl -Ls $ANT_TGZ_URL > apache-tomcat-x-src.tar.gz \
    && tar -xf apache-ant-x-bin.tar.bz2 \
    && tar -xf apache-tomcat-x-src.tar.gz

# Build tomcat using ant
RUN cd apache-tomcat-*-src && ../apache-ant-*/bin/ant -silent

# Stage 2: Copy tomcat from builder image
# =======================================
FROM herveleclerc/docker-alpine-java8-jre:latest

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

COPY --from=builder /tmp/apache-tomcat-*-src/output/build $CATALINA_HOME

EXPOSE 8080
CMD ["catalina.sh", "run"]