FROM docker.io/library/debian:12
LABEL CREATEDBY "Matthew Stobbs <matthew.stobbs@ucalgary.ca>"

ARG DEBIAN_FRONTEND=noninteractive
ARG CANDIG_REPO=https://github.com/CanDIG/CanDIGv2.git
ARG BRANCH=stable
ARG YQBINARY=yq_linux_amd64
ARG YQVERSION=v4.44.1

RUN apt-get update && \
	apt-get install -y ca-certificates curl && \
	install -m 0755 -d /etc/apt/keyrings && \
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
	chmod a+r /etc/apt/keyrings/docker.asc

RUN echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	tee /etc/apt/sources.list.d/docker.list > /dev/null && \
	apt-get update && \
	apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
	apt-get install -y  build-essential gettext jq && \
	systemctl disable docker

RUN apt-get install -y build-essential git-core

RUN env > /tmp/env.txt
RUN cat /tmp/env.txt

# Install yq binary
RUN curl -L https://github.com/mikefarah/yq/releases/download/${YQVERSION}/${YQBINARY} -o /usr/bin/yq && \
	chmod +x /usr/bin/yq

# Fetch candig code
RUN git clone -b ${BRANCH} --recurse-submodules ${CANDIG_REPO} /candig

WORKDIR /candig
ENTRYPOINT ["make", "install-all"]
