#
# Copyright (c) 2019
# IOTech
#
# SPDX-License-Identifier: Apache-2.0
#
ARG DOCKER_VERSION=18.09.5
FROM docker:${DOCKER_VERSION} AS docker-cli

FROM alpine:3.9

LABEL license='SPDX-License-Identifier: Apache-2.0' \
  copyright='Copyright (c) 2019: IOTech'

LABEL maintainer="Bruce Huang <bruce@iotechsys.com>"

COPY --from=docker-cli  /usr/local/bin/docker   /usr/local/bin/docker
COPY robot-entrypoint.sh /usr/local/bin/

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    apk add --no-cache tzdata      &&  \
    cp /usr/share/zoneinfo/UTC /etc/localtime  &&  \
    apk del tzdata  &&  \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    \
    echo "**** install robotframework and dependencies ****" && \
    python3 -m pip install robotframework && \
    pip3 install docker  &&  \
    pip3 install -U python-dotenv  &&  \
    pip3 install -U RESTinstance
ENTRYPOINT ["sh", "/usr/local/bin/robot-entrypoint.sh"]
