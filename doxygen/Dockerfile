ARG FEDORA=latest
ARG JOBS=4

#
# Documentation toolchain
#

FROM fedora:${FEDORA} AS doxygen

RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
    && dnf update -y \
    && dnf install -y \
	doxygen \
	gcc \
	make \
    && dnf clean all -y

FROM doxygen AS check-doxygen

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} doc

#
# Specify the default target
#

FROM doxygen AS default
