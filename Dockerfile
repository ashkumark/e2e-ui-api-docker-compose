#FROM maven:3.8.3-openjdk-8
FROM jenkins/jenkins:lts

WORKDIR /docker-jenkins-test

COPY src /docker-jenkins-test/src
COPY pom.xml /docker-jenkins-test

USER root

# Install necessary tools
RUN apt-get update && \
    apt-get install -y vim wget curl jq unzip bash tar --no-install-recommends


#WORKDIR /home/docker-jenkins-test
#COPY src /home/docker-jenkins-test/src
#COPY pom.xml /home/docker-jenkins-test

#ENV JAVA_OPTS="-Xmx8192m"
#ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log"

#USER root

#RUN apt-get update
#RUN apt-get install -y wget curl unzip sudo tar --no-install-recommends
# ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# #Maven
# ENV MAVEN_VERSION 3.9.5
# #https://sharadchhetri.com/install-setup-maven-linux-jenkins/
#
# RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
# RUN mkdir -p /opt/maven
# RUN tar -xvzf apache-maven-3.9.5-bin.tar.gz -C /opt/maven/ --strip-components=1
# RUN ln -s /opt/maven/bin/mvn /usr/bin/mvn
#
#
# RUN mkdir /var/log/jenkins
# RUN chown -R  jenkins:jenkins /var/log/jenkins

#Docker - https://docs.docker.com/engine/api/
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 23.0.6
ENV DOCKER_API_VERSION 1.42
RUN curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
  | tar -xzC /usr/local/bin --strip=1 docker/docker

#Docker compose - https://docs.docker.com/compose/release-notes/
ENV DOCKER_COMPOSE_VERSION v2.21.0
RUN curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" \
    -o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

#RUN useradd jenkins

RUN groupadd docker
RUN usermod -aG docker jenkins

# Create a runner script for the entrypoint
COPY runner.sh /docker-jenkins-test
RUN chmod +x ./runner.sh

USER jenkins

ENTRYPOINT ["./runner.sh"]