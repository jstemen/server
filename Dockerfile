FROM jstemen/arm32v7-base:latest
MAINTAINER ownCloud DevOps <devops@owncloud.com>

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

ARG OWNCLOUD_TARBALL
ARG LDAP_TARBALL
ARG LDAP_CHECKSUM


RUN curl -sLo - ${OWNCLOUD_TARBALL} | tar xfj - --strip 1 -C /var/www/owncloud
#ADD owncloud-${VERSION}.tar.bz2 /var/www/

RUN curl -sLo user_ldap.tar.gz ${LDAP_TARBALL} && \
  echo "$LDAP_CHECKSUM user_ldap.tar.gz" | sha256sum -c - && \
  mkdir -p /var/www/owncloud/apps/user_ldap && \
  tar xfz user_ldap.tar.gz -C /var/www/owncloud/apps/user_ldap --strip-components 1 && \
  rm -f user_ldap.tar.gz

RUN chown -R www-data:www-data /var/www/owncloud 


LABEL \
  org.label-schema.version=$VERSION \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/owncloud-docker/server.git" \
  org.label-schema.name="ownCloud Server" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

