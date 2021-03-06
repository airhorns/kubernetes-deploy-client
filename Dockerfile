FROM ruby:2.5.1-alpine
ENV CLOUD_SDK_VERSION 203.0.0

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
        curl \
        python \
        wget \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components install --quiet kubectl && \
    gcloud --version

ENV DOCKER_CLIENT_VERSION "18.03.1-ce"
RUN curl -L -o /tmp/docker-$DOCKER_CLIENT_VERSION.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLIENT_VERSION.tgz \
    && tar -xz -C /tmp -f /tmp/docker-$DOCKER_CLIENT_VERSION.tgz \
    && mv /tmp/docker/docker /usr/bin \
    && rm -rf /tmp/docker-$DOCKER_CLIENT_VERSION /tmp/docker

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN pip install 'docker-compose==1.21.2' && \
    docker-compose --version

VOLUME ["/root/.config"]
