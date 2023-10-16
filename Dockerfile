

#FROM maven:3.8.3-openjdk-8
FROM jenkins/jenkins:lts
LABEL maintainer="ash"

WORKDIR /docker-jenkins-test

COPY src /docker-jenkins-test/src
COPY pom.xml /docker-jenkins-test

ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log"

USER root

# Install necessary tools
RUN apt-get update && \
    apt-get install -y vim wget curl jq unzip bash sudo --no-install-recommends

RUN mkdir /var/log/jenkins
RUN chown -R  jenkins:jenkins /var/log/jenkins

#USER jenkins

#RUN usermod -a -G docker jenkins
  
# Expose ports
EXPOSE 5901
    
# Create a runner script for the entrypoint
COPY runner.sh /docker-jenkins-test
RUN chmod +x ./runner.sh

ENTRYPOINT ["./runner.sh"]
