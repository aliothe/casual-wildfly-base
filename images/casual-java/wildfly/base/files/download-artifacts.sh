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

