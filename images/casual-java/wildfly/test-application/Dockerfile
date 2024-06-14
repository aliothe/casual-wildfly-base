FROM casual-wildfly-base:latest

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
