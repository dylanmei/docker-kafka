FROM debian:jessie

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# JAVA
ENV JAVA_MAJOR_VERSION 8
ENV JAVA_UPDATE_VERSION 102
ENV JAVA_BUILD_NUMBER 14
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man

# KAFKA
ENV KAFKA_VERSION 0.10.0.1
ENV KAFKA_HOME /usr/kafka_2.11-${KAFKA_VERSION}
RUN curl -sL --retry 3 \
  "http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $KAFKA_HOME/site-docs \
 && sed -i -r "/#advertised.listeners/s/#//g" $KAFKA_HOME/config/server.properties \
 && sed -i -r "s/(advertised.listeners)=(.*)/\1=PLAINTEXT:\/\/localhost:9092/g" $KAFKA_HOME/config/server.properties \
 && sed -i -r "s/(zookeeper.connect)=(.*)/\1=zookeeper:2181/g" $KAFKA_HOME/config/server.properties \
 && chown -R root:root $KAFKA_HOME

WORKDIR $KAFKA_HOME
CMD bin/kafka-server-start.sh config/server.properties
