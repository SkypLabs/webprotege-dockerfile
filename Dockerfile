FROM tomcat:8.5
MAINTAINER Paul-Emmanuel Raoul <skyper@skyplabs.net>

ENV WEBPROTEGE_VERSION="2.6.0"
ENV JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"

WORKDIR /usr/local/tomcat/webapps
RUN rm -rf * \
    && mkdir -p /data/webprotege \
    && wget -q -O webprotege.war https://github.com/protegeproject/webprotege/releases/download/v${WEBPROTEGE_VERSION}/webprotege-${WEBPROTEGE_VERSION}.war \
    && unzip -q webprotege.war -d ROOT \
    && rm webprotege.war

COPY config/webprotege.properties ROOT/WEB-INF/classes/webprotege.properties

RUN sed -i "s/\(application.version *= *\).*/\1$WEBPROTEGE_VERSION/" ROOT/WEB-INF/classes/webprotege.properties

EXPOSE 8080
CMD ["catalina.sh", "run"]
