FROM ubuntu:22.04

# install java
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install default-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install apt-utils && apt-get install -y \
curl && apt-get install -y wget && apt-get install unzip -y

RUN echo java --version

ARG GRADLE_VERSION=6.9.4
RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt \
    && rm gradle-${GRADLE_VERSION}-bin.zip

VOLUME /root/.gradle

ENV GRADLE_HOME /opt/gradle-${GRADLE_VERSION}
ENV PATH $PATH:/opt/gradle-${GRADLE_VERSION}/bin


RUN export JAVA_HOME="$(dirname $(dirname $(readlink -f $(which java))))"

ARG WRKDIR=/app/projects

RUN echo "${WRKDIR}"

USER root

# EXPOSE 2030

WORKDIR ${WRKDIR}

RUN mkdir -p ${WRKDIR}
COPY ./ ${WRKDIR}/

# RUN gradle clean build

# this keeps the container running until a cmd starts a server
# ENTRYPOINT [WORKDIR, "java", "main.java"]

RUN echo WORKDIR

CMD [ "./gradlew", "run" ]