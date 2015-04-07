#
# Opal Dockerfile
#
# https://github.com/obiba/docker-opal
#

# Pull base image
FROM java:8

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install Opal
RUN \
  wget -q -O - http://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb http://pkg.obiba.org unstable/' | tee /etc/apt/sources.list.d/obiba.list && \
  echo opal opal-server/admin_password select password | debconf-set-selections && \
  echo opal opal-server/admin_password_again select password | debconf-set-selections

COPY bin /opt/opal/bin
COPY data /opt/opal/data

RUN chmod +x -R /opt/opal/bin

# Define default command.
ENTRYPOINT ["bash", "-c", "/opt/opal/bin/start.sh"]

# https
EXPOSE 8443
# http
EXPOSE 8080
