FROM tomcat:8.5

LABEL net.skyplabs.maintainer-name="Paul-Emmanuel Raoul"
LABEL net.skyplabs.maintainer-email="skyper@skyplabs.net"

ARG WEBPROTEGE_VERSION="3.0.0"
ARG WEBPROTEGE_DOWNLOAD_BASE_URL=https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}

ENV webprotege.application.version=${WEBPROTEGE_VERSION}
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR /usr/local/tomcat/webapps
RUN rm -rf ./* \
    && mkdir -p /srv/webprotege \
    && wget -q -O webprotege.war ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}.war \
    && unzip -q webprotege.war -d ROOT \
    && rm webprotege.war

COPY config/webprotege.properties /etc/webprotege/webprotege.properties
COPY config/mail.properties /etc/webprotege/mail.properties

RUN mkdir /usr/local/share/java \
    && wget -q -O /usr/local/share/java/webprotege-cli ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}-cli.jar

COPY scripts/webprotege-cli /usr/local/bin/webprotege-cli

EXPOSE 8080
VOLUME /srv/webprotege

CMD ["catalina.sh", "run"]
