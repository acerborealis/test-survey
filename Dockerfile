# derived and inspired from https://github.com/Kharatsa/odkaggregate
FROM resin/rpi-raspbian
MAINTAINER Mathieu Bossaert

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get upgrade
RUN apt-get install openjdk-7-jdk
RUN apt-get install wget
RUN apt-get install pwgen
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 6
ENV TOMCAT_MINOR_VERSION 6.0.45
ENV CATALINA_HOME /tomcat
# To be improve : ODKAggregate IP as a variable
ENV ODK_PORT='8080'
ENV ODK_HOSTNAME='192.168.1.131'
ENV ODK_ADMIN_USERNAME='odk_boss'
ENV ODK_ADMIN_USER_EMAIL='mailto:toto@gmail.com'
ENV ODK_AUTH_REALM='ODK Aggregate'

# TOMCAT INSTALL 
RUN wget https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

# PostregSQL JDBC driver. See https://jdbc.postgresql.org/download.html
# Need to be more generic...
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1209.jre7.jar && \
    mv postgresql-9.4.1209.jre7.jar ${CATALINA_HOME}/lib/

# ODK Aggregate WAR archive
RUN wget https://github.com/acerborealis/test-survey/raw/master/ODKAggregate.war 
    
# create_tomcat_admin_user.sh
RUN wget https://github.com/acerborealis/test-survey/raw/master/create_tomcat_admin_user.sh 

# run.sh
RUN wget https://github.com/acerborealis/test-survey/raw/master/run.sh

RUN chmod +x /*.sh

EXPOSE ${ODK_PORT}

ENTRYPOINT ["/run.sh"]
