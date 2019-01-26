FROM tomcat:8.5

LABEL net.skyplabs.maintainer-name="Paul-Emmanuel Raoul"
LABEL net.skyplabs.maintainer-email="skyper@skyplabs.net"

ARG WEBPROTEGE_VERSION="3.0.0"
ENV webprotege.application.version ${WEBPROTEGE_VERSION}
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR /usr/local/tomcat/webapps
RUN rm -rf ./* \
    && mkdir -p /srv/webprotege \
    && wget -q -O webprotege.war https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}/webprotege-${WEBPROTEGE_VERSION}.war \
    && unzip -q webprotege.war -d ROOT \
    && rm webprotege.war

COPY config/webprotege.properties /etc/webprotege/webprotege.properties
COPY config/mail.properties /etc/webprotege/mail.properties

EXPOSE 8080
VOLUME /srv/webprotege

CMD ["catalina.sh", "run"]
