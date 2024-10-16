FROM tomcat:10-jdk21-temurin-jammy
RUN groupadd -r mcr -g 501 && \
    useradd -d /home/mcr -u 501 -m -s /bin/bash -g mcr mcr
WORKDIR /usr/local/tomcat/
ARG PACKET_SIZE="65536"
ENV APP_CONTEXT="cug" \
 MCR_CONFIG_DIR="/mcr/home/" \
 MCR_DATA_DIR="/mcr/data/" \
 MCR_LOG_DIR="/mcr/logs/" \
 SOLR_CORE="cug" \
 SOLR_CLASSIFICATION_CORE="cug-classifications" \
 XMX="1g" \
 XMS="1g"
COPY --chown=root:root docker-entrypoint.sh /usr/local/bin/cug.sh

RUN set -eux; \
    chmod 555 /usr/local/bin/cug.sh; \
	apt-get update; \
	apt-get install -y gosu; \
	rm -rf /var/lib/apt/lists/*;
RUN rm -rf /usr/local/tomcat/webapps/* && \
    mkdir /opt/cug/ && \
    chown mcr:mcr -R /opt/cug/ && \
    sed -ri "s/<\/Service>/<Connector protocol=\"AJP\/1.3\" packetSize=\"$PACKET_SIZE\" tomcatAuthentication=\"false\" scheme=\"https\" secretRequired=\"false\" allowedRequestAttributesPattern=\".*\" encodedSolidusHandling=\"decode\" address=\"0.0.0.0\" port=\"8009\" redirectPort=\"8443\" \/>&/g" /usr/local/tomcat/conf/server.xml
COPY --chown=mcr:mcr profkat_cug-webapp/target/profkat_cug-*.war /opt/cug/cug.war
COPY --chown=mcr:mcr profkat_cug-cli/target/appassembler /opt/cug/cug-cli
COPY --chown=mcr:mcr docker-log4j2.xml /opt/cug/log4j2.xml
RUN chown mcr:mcr -R /opt/cug/ /usr/local/tomcat/webapps/
CMD ["bash", "/usr/local/bin/cug.sh"]
