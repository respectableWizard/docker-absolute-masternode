FROM ubuntu:xenial
MAINTAINER respectableWizard <respectableWizard@gmail.com>

ARG USER_ID
ARG GROUP_ID
ARG VERSION

ENV USER absolute
ENV HOME /home/${USER}
ENV PORT 18888

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} ${USER} \
	&& useradd -u ${USER_ID} -g ${USER} -s /bin/bash -m -d ${HOME} ${USER}

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.11

RUN set -x \
    && apt-get update  \
    && apt-get install -y --no-install-recommends ca-certificates wget software-properties-common curl jq \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && gosu nobody true

RUN set -x \
    && apt-get update && apt-get install -y libminiupnpc-dev python-virtualenv git virtualenv cron \
    && mkdir -p /sentinel \
    && cd /sentinel \
    && git clone https://github.com/absolute-community/sentinel.git . \
    && virtualenv ./venv \
    && ./venv/bin/pip install -r requirements.txt \
    && touch sentinel.log \
    && chown -R ${USER} /sentinel \
    && echo '* * * * * '${USER}' cd /sentinel && SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1' >> /etc/cron.d/sentinel \
    && chmod 0644 /etc/cron.d/sentinel \
    && touch /var/log/cron.log

COPY tools/get-node.sh ./get-node.sh

# set execution rights
RUN chmod +x ./get-node.sh
# get latest absolute binaries
RUN ./get-node.sh

EXPOSE ${PORT}
VOLUME ["${HOME}"]
WORKDIR ${HOME}
ADD ./bin /usr/local/bin
RUN chmod 777 /usr/local/bin/start-unprivileged.sh \
    /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start-unprivileged.sh"]
