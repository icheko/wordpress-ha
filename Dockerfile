FROM wordpress:4-apache

MAINTAINER Jose Pacheco <jose@icheko.com>
ENV CONTAINER_MODE master
ENV SUPERVISOR_ADDL_CONFIGS /etc/supervisor/conf.d

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        rsync \
        supervisor \
        python-pip \
    && pip install j2cli

COPY rsync-exclude.txt /etc
COPY rsync-server.conf /etc/rsyncd.conf
COPY rsync-client.sh /usr/local/bin/

COPY apache-server.tpl ${SUPERVISOR_ADDL_CONFIGS}
COPY apache-slave.htaccess /var/www
COPY rsync-server.tpl ${SUPERVISOR_ADDL_CONFIGS}
COPY rsync-client.tpl ${SUPERVISOR_ADDL_CONFIGS}

COPY docker-entrypoint-custom.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/
RUN    chmod +x /usr/local/bin/docker-entrypoint-custom.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/rsync-client.sh

ENTRYPOINT ["docker-entrypoint-custom.sh"]