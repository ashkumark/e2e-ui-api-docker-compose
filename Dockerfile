

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

# install Docker
    RUN apt-get update
    RUN apt-get install -y apt-transport-https ca-certificates software-properties-common
    RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    RUN apt-cache policy docker-ce
    RUN apt-get install -y docker-ce

    RUN usermod -aG docker ubuntu

#USER jenkins
    #USER jenkins
  
# Expose ports
EXPOSE 5901
    
# Create a runner script for the entrypoint
COPY runner.sh /docker-jenkins-test
RUN chmod +x ./runner.sh

ENTRYPOINT ["./runner.sh"]
