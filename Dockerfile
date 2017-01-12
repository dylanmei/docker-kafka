FROM debian:jessie

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# JAVA
ENV JAVA_MAJOR_VERSION 8
ENV JAVA_UPDATE_VERSION 112
ENV JAVA_BUILD_NUMBER 15
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV PATH $PATH:$JAVA_HOME/bin
RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /usr/ \
 && ln -s $JAVA_HOME /usr/java \
 && rm -rf $JAVA_HOME/man

# JOLOKIA
ENV JOLOKIA_VERSION 1.3.5
ENV JOLOKIA_HOME /usr/jolokia-${JOLOKIA_VERSION}
RUN curl -sL --retry 3 \
  "https://github.com/rhuss/jolokia/releases/download/v${JOLOKIA_VERSION}/jolokia-${JOLOKIA_VERSION}-bin.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && ln -s $JOLOKIA_HOME /usr/jolokia \
 && rm -rf $JOLOKIA_HOME/client \
 && rm -rf $JOLOKIA_HOME/reference

# KAFKA
ENV KAFKA_VERSION 0.10.1.1
ENV KAFKA_HOME /usr/kafka_2.11-${KAFKA_VERSION}
RUN curl -sL --retry 3 \
  "http://www.us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz" \
  | gunzip \
  | tar -x -C /usr/ \
 && chown -R root:root $KAFKA_HOME \
 && mv $KAFKA_HOME/config /etc/kafka \
 && ln -s /etc/kafka $KAFKA_HOME/config \
 && rm -rf $KAFKA_HOME/site-docs

WORKDIR $KAFKA_HOME
CMD ["bin/kafka-server-start.sh", "config/server.properties", "--override", "advertised.listeners=PLAINTEXT://localhost:9092", "--override", "zookeeper.connect=zookeeper:2181"]
