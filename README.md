# Casual wildfly base

Base image with:
* wildfly 32.0.1-Final
* casual-jca 3.2.42
* casual-caller 3.2.17


## Dockerfile used to create the image

```
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

```

The script that downloads the artifacts `download-artifacts.sh`:

```sh
#!/bin/env sh
#-*- coding: utf-8-unix -*-

wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-inbound-handler-api/$CASUAL_VERSION/casual-inbound-handler-api-$CASUAL_VERSION.jar
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-fielded-annotations/$CASUAL_VERSION/casual-fielded-annotations-$CASUAL_VERSION.jar
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-service-discovery-extension/$CASUAL_VERSION/casual-service-discovery-extension-$CASUAL_VERSION.jar
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-api/$CASUAL_VERSION/casual-api-$CASUAL_VERSION.jar
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-event-api/$CASUAL_VERSION/casual-event-api-$CASUAL_VERSION.jar

wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-jca-app/$CASUAL_VERSION/casual-jca-app-$CASUAL_VERSION.ear
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-inbound-startup-trigger-app/$CASUAL_VERSION/casual-inbound-startup-trigger-app-$CASUAL_VERSION.ear
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/se/laz/casual/casual-caller-app/$CASUAL_CALLER_VERSION/casual-caller-app-$CASUAL_CALLER_VERSION.ear

wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/com/google/code/gson/gson/$GSON_VERSION/gson-$GSON_VERSION.jar
wget -P /opt/jboss/wildfly/casual https://repo1.maven.org/maven2/org/objenesis/objenesis/$OBJENESIS_VERSION/objenesis-$OBJENESIS_VERSION.jar

```


# Example application 

## Dockerfile

```
FROM casual-wildfly-base:3.2.42

RUN /opt/jboss/wildfly/bin/add-user.sh asdf asdf1 --silent

COPY files/casual-fields.json /casual-fields.json
ENV CASUAL_FIELD_TABLE /casual-fields.json

COPY files/casual-config.json /casual-config.json
ENV CASUAL_CONFIG_FILE /casual-config.json

ENV CASUAL_INBOUND_STARTUP_MODE trigger
ENV CASUAL_HOST=casual
ENV CASUAL_PORT=7771

ENV CASUAL_TEST_APPLICATION_VERSION 2.0.3
ENV CASUAL_DOMAIN_NAME=wildfly

COPY files/casual-test-app-${CASUAL_TEST_APPLICATION_VERSION}.war ${WILDFLY_HOME}/standalone/deployments

COPY files/setup.cli /tmp
RUN ${WILDFLY_HOME}/bin/jboss-cli.sh --file=/tmp/setup.cli
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current

CMD ["/opt/jboss/wildfly/bin/standalone.sh",  "-c", "standalone-full.xml", "--debug", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
```

### Example cli configuration 

A `setup-cli.sh` could look as follows:

```
embed-server --server-config=standalone-full.xml --std-out=echo

set CASUAL_VERSION=${env.CASUAL_VERSION}
set CASUAL_CALLER_VERSION=${env.CASUAL_CALLER_VERSION}
set CASUAL_ROOT=${env.CASUAL_ROOT}
set CASUAL_DOMAIN_NAME=${env.CASUAL_DOMAIN_NAME}
set CASUAL_HOST=${env.CASUAL_HOST}
set CASUAL_PORT=${env.CASUAL_PORT}

# global module
/subsystem=ee:list-add(name=global-modules, value={name=se.laz.casual})

# create a unique transaction node identifier 
/system-property=jboss.tx.node.id:add(value='wildfly-only')

# configure casual RA
set baseNode=/subsystem=resource-adapters/resource-adapter=casual-jca
$baseNode:add(archive=casual-jca-app-$CASUAL_VERSION.ear#casual-jca.rar,transaction-support=XATransaction)

set connectionDefinitionNode=$baseNode/connection-definitions=casual-pool
$connectionDefinitionNode:add(\
    class-name=se.laz.casual.jca.CasualManagedConnectionFactory,\
    jndi-name=eis/casualConnectionFactoryDefault,\
    min-pool-size=100, initial-pool-size=100, max-pool-size=100,\
    enabled=true,background-validation=false,validate-on-match=false)

$connectionDefinitionNode/config-properties=HostName:add(value=$CASUAL_HOST)
$connectionDefinitionNode/config-properties=PortNumber:add(value=$CASUAL_PORT)
$connectionDefinitionNode/config-properties=NetworkConnectionPoolName:add(value=pool-one)
$connectionDefinitionNode/config-properties=NetworkConnectionPoolSize:add(value=1)

deploy $CASUAL_ROOT/casual-jca-app-$CASUAL_VERSION.ear
deploy $CASUAL_ROOT/casual-caller-app-$CASUAL_CALLER_VERSION.ear
deploy $CASUAL_ROOT/casual-inbound-startup-trigger-app-$CASUAL_VERSION.ear

stop-embedded-server
```

Note that it also deploys the applications provided by the `casual-wildfly-base` image.

