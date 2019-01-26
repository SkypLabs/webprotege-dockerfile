FROM tomcat:8.5

LABEL net.skyplabs.maintainer-name="Paul-Emmanuel Raoul"
LABEL net.skyplabs.maintainer-email="skyper@skyplabs.net"

ARG WEBPROTEGE_VERSION="3.0.0"
ARG WEBPROTEGE_DATA_DIR=/srv/webprotege
ARG WEBPROTEGE_DOWNLOAD_BASE_URL=https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}

ENV webprotege.application.version=${WEBPROTEGE_VERSION}
ENV webprotege.data.directory=${WEBPROTEGE_DATA_DIR}
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR ${CATALINA_HOME}/webapps

RUN rm -rf ${CATALINA_HOME}/webapps/*               &&\
    mkdir -p ${WEBPROTEGE_DATA_DIR}                 &&\
    mkdir -p /usr/local/share/java                  &&\
    mkdir -p mkdir /var/log/webprotege              &&\
    useradd -r -M -s /usr/sbin/nologin webprotege   &&\
    chown webprotege: ${WEBPROTEGE_DATA_DIR}        &&\
    chown webprotege: /var/log/webprotege

ADD ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}.war ./webprotege.war
ADD ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}-cli.jar /usr/local/share/java/

RUN unzip -q webprotege.war -d ROOT \
    && rm webprotege.war

COPY config/webprotege.properties /etc/webprotege/webprotege.properties
COPY config/mail.properties /etc/webprotege/mail.properties
COPY scripts/webprotege-cli /usr/local/bin/webprotege-cli

EXPOSE 8080
VOLUME /srv/webprotege

USER webprotege

CMD ["catalina.sh", "run"]
