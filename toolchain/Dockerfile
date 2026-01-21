ARG FEDORA=latest
ARG JOBS=4

#
# Baseline for all architectures
#

FROM fedora:${FEDORA} AS baseline

RUN dnf update -y \
    && dnf install -y \
	cross-binutils-common \
	cross-gcc-common \
	gcc \
	make \
	perl-interpreter \
	qemu-user \
    && dnf clean all -y

#
# Source code snapshot for build check
#

FROM baseline AS source

RUN dnf install -y \
	git-core \
    && dnf clean all -y

RUN git clone --depth 1 https://github.com/ipxe/ipxe

#
# x86_64 toolchain
#

FROM baseline AS x86_64

RUN dnf install -y \
	genisoimage \
	mtools \
	perl-FindBin \
	syslinux \
	xz-devel \
    && dnf clean all -y

FROM x86_64 AS check-x86_64

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-x86_64-efi/snponly.efi

#
# i386 toolchain
#

FROM x86_64 AS i386

FROM i386 AS check-i386

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-i386-efi/snponly.efi

#
# arm64 toolchain
#

FROM baseline AS arm64

RUN dnf install -y \
	gcc-aarch64-linux-gnu \
    && dnf clean all -y

ENV CROSS_COMPILE_arm64=aarch64-linux-gnu-

FROM arm64 AS check-arm64

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-arm64-efi/snponly.efi

#
# arm32 toolchain
#

FROM baseline AS arm32

RUN dnf install -y \
	gcc-arm-linux-gnu \
    && dnf clean all -y

ENV CROSS_COMPILE_arm32=arm-linux-gnu-

FROM arm32 AS check-arm32

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-arm32-efi/snponly.efi

#
# loong64 toolchain
#

FROM baseline AS loong64

RUN dnf install -y \
	gcc-loongarch64-linux-gnu \
    && dnf clean all -y

ENV CROSS_COMPILE_loong64=loongarch64-linux-gnu-

FROM loong64 AS check-loong64

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-loong64-efi/snponly.efi

#
# riscv64 toolchain
#

FROM baseline AS riscv64

RUN dnf install -y \
	gcc-riscv64-linux-gnu \
    && dnf clean all -y

ENV CROSS_COMPILE_riscv64=riscv64-linux-gnu-

FROM riscv64 AS check-riscv64

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-riscv64-efi/snponly.efi

#
# riscv32 toolchain
#

FROM riscv64 AS riscv32

ENV CROSS_COMPILE_riscv32=riscv64-linux-gnu-

FROM riscv32 AS check-riscv32

ARG JOBS
ENV JOBS=${JOBS}

COPY --from=source /ipxe/src /ipxe/src/

CMD make -C /ipxe/src -j ${JOBS} bin-riscv32-efi/snponly.efi

#
# Specify the default target
#

FROM x86_64 AS default
