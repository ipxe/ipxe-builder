ARG FEDORA=latest

FROM fedora:${FEDORA} AS signer

RUN dnf update -y \
    && dnf install -y \
	opensc \
	osslsigncode \
    && dnf clean all -y
