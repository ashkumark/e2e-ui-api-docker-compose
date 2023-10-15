

FROM maven:3.8.3-openjdk-8

WORKDIR /docker-jenkins-test

COPY src /docker-jenkins-test/src
COPY pom.xml /docker-jenkins-test

USER root

# Install necessary tools
RUN apt-get update && \
    apt-get install -y vim wget curl jq unzip bash --no-install-recommends
    
# Create a runner script for the entrypoint
COPY runner.sh /docker-jenkins-test
RUN chmod +x ./runner.sh

ENTRYPOINT ["./runner.sh"]