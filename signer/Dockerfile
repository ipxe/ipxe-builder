ARG FEDORA=latest

#
# Signing toolchain
#

FROM fedora:${FEDORA} AS signer

RUN dnf update -y \
    && dnf install -y \
	genisoimage \
	mtools \
	opensc \
	osslsigncode \
	syslinux \
    && dnf clean all -y

#
# Specify the default target
#

FROM signer AS default
