FROM tomcat:8-alpine

LABEL net.skyplabs.maintainer.name="Paul-Emmanuel Raoul"
LABEL net.skyplabs.maintainer.email="skyper@skyplabs.net"
LABEL version="2.0.0"

ARG WEBPROTEGE_VERSION="3.0.0"
ARG WEBPROTEGE_DATA_DIR=/srv/webprotege
ARG WEBPROTEGE_LOG_DIR=/var/log/webprotege
ARG WEBPROTEGE_DOWNLOAD_BASE_URL=https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}

ENV webprotege.application.version=${WEBPROTEGE_VERSION}
ENV webprotege.data.directory=${WEBPROTEGE_DATA_DIR}
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR ${CATALINA_HOME}/webapps

RUN rm -rf ./*                                                                  &&\
    mkdir -p ${CATALINA_HOME}/webapps/ROOT                                      &&\
    mkdir -p ${WEBPROTEGE_DATA_DIR}                                             &&\
    mkdir -p ${WEBPROTEGE_LOG_DIR}                                             &&\
    mkdir -p /usr/local/share/java                                              &&\
    adduser -S -D -s /sbin/nologin -H -h /dev/null -g webprotege webprotege     &&\
    chown webprotege: ${WEBPROTEGE_DATA_DIR}                                    &&\
    chown webprotege: ${WEBPROTEGE_LOG_DIR}                                    &&\
    wget -q -O webprotege.war \
      ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}.war      &&\
    wget -q -O /usr/local/share/java/webprotege-cli \
      ${WEBPROTEGE_DOWNLOAD_BASE_URL}/webprotege-${WEBPROTEGE_VERSION}-cli.jar  &&\
    unzip -q webprotege.war -d ROOT                                             &&\
    rm -f webprotege.war

COPY config/webprotege.properties /etc/webprotege/webprotege.properties
COPY config/mail.properties /etc/webprotege/mail.properties
COPY scripts/webprotege-cli /usr/local/bin/webprotege-cli

EXPOSE 8080
VOLUME ${WEBPROTEGE_DATA_DIR}
VOLUME ${WEBPROTEGE_LOG_DIR}

USER webprotege

CMD ["catalina.sh", "run"]
