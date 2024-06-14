FROM quay.io/wildfly/wildfly:32.0.1.Final-jdk21

USER root

USER 1001

RUN mkdir /opt/jboss/wildfly/casual

ENV CASUAL_VERSION 3.2.42
ENV CASUAL_CALLER_VERSION 3.2.17
ENV GSON_VERSION 2.11.0
ENV OBJENESIS_VERSION 3.4

ENV CASUAL_ROOT /opt/jboss/wildfly/casual
ENV CASUAL_CALLER_CONNECTION_FACTORY_JNDI_SEARCH_ROOT=java:/eis

COPY files/download-artifacts.sh ${CASUAL_ROOT}
RUN ${CASUAL_ROOT}/download-artifacts.sh

RUN /opt/jboss/wildfly/bin/jboss-cli.sh --command="module add --name=se.laz.casual \
	--resources=/opt/jboss/wildfly/casual/casual-inbound-handler-api-${CASUAL_VERSION}.jar:/opt/jboss/wildfly/casual/casual-fielded-annotations-${CASUAL_VERSION}.jar:/opt/jboss/wildfly/casual/casual-service-discovery-extension-${CASUAL_VERSION}.jar:/opt/jboss/wildfly/casual/casual-api-${CASUAL_VERSION}.jar:/opt/jboss/wildfly/casual/casual-event-api-${CASUAL_VERSION}.jar:/opt/jboss/wildfly/casual/gson-${GSON_VERSION}.jar:/opt/jboss/wildfly/casual/objenesis-${OBJENESIS_VERSION}.jar \
                --dependencies=javaee.api,sun.jdk"

ENV WILDFLY_HOME=/opt/jboss/wildfly

USER root

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt

USER 1001

EXPOSE 8080 7772 9990 
