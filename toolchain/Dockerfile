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
	genisoimage \
	make \
	mtools \
	perl-interpreter \
	qemu-user \
	syslinux \
	xz-devel \
    && dnf clean all -y

#
# x86_64 toolchain
#

FROM baseline AS x86_64

RUN dnf install -y \
	perl-FindBin \
	perl-lib \
    && dnf clean all -y

FROM x86_64 AS check-x86_64

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-x86_64-pcbios/intel.mrom bin-x86_64-pcbios/ipxe.iso \
	bin-x86_64-efi/snponly.efi bin-x86_64-efi/ipxe.iso \
	bin-x86_64-linux/tests.linux && \
    /ipxe/src/bin-x86_64-linux/tests.linux

#
# i386 toolchain
#

FROM x86_64 AS i386

RUN dnf install -y \
	glibc-devel.i686 \
    && dnf clean all -y

FROM i386 AS check-i386

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin/intel.mrom bin/ipxe.iso \
	bin-i386-efi/snponly.efi bin-i386-efi/ipxe.iso \
	bin-i386-linux/tests.linux && \
    /ipxe/src/bin-i386-linux/tests.linux

#
# arm64 toolchain
#

FROM baseline AS arm64

RUN dnf install -y \
	gcc-aarch64-linux-gnu \
    && dnf clean all -y

COPY --from=ghcr.io/ipxe/sysroot-arm64 / /usr/aarch64-linux-gnu/sys-root/

ENV CROSS_COMPILE_arm64=aarch64-linux-gnu-

ENV QEMU_LD_PREFIX=/usr/aarch64-linux-gnu/sys-root

FROM arm64 AS check-arm64

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-arm64-efi/snponly.efi bin-arm64-efi/ipxe.iso \
	bin-arm64-linux/tests.linux && \
    qemu-aarch64 /ipxe/src/bin-arm64-linux/tests.linux

#
# arm32 toolchain
#

FROM baseline AS arm32

RUN dnf install -y \
	gcc-arm-linux-gnu \
    && dnf clean all -y

COPY --from=ghcr.io/ipxe/sysroot-arm32 / /usr/arm-linux-gnu/sys-root/

ENV CROSS_COMPILE_arm32=arm-linux-gnu-

ENV QEMU_LD_PREFIX=/usr/arm-linux-gnu/sys-root

FROM arm32 AS check-arm32

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-arm32-efi/snponly.efi bin-arm32-efi/ipxe.iso \
	bin-arm32-linux/tests.linux && \
    qemu-arm /ipxe/src/bin-arm32-linux/tests.linux

#
# loong64 toolchain
#

FROM baseline AS loong64

RUN dnf install -y \
	gcc-loongarch64-linux-gnu \
    && dnf clean all -y

COPY --from=ghcr.io/ipxe/sysroot-loong64 / /usr/loongarch64-linux-gnu/sys-root/

ENV CROSS_COMPILE_loong64=loongarch64-linux-gnu-

ENV QEMU_LD_PREFIX=/usr/loongarch64-linux-gnu/sys-root

FROM loong64 AS check-loong64

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-loong64-efi/snponly.efi bin-loong64-efi/ipxe.iso \
	bin-loong64-linux/tests.linux && \
    qemu-loongarch64 /ipxe/src/bin-loong64-linux/tests.linux

#
# riscv64 toolchain
#

FROM baseline AS riscv64

RUN dnf install -y \
	gcc-riscv64-linux-gnu \
    && dnf clean all -y

COPY --from=ghcr.io/ipxe/sysroot-riscv64 / /usr/riscv64-linux-gnu/sys-root/

ENV CROSS_COMPILE_riscv64=riscv64-linux-gnu-

ENV QEMU_LD_PREFIX=/usr/riscv64-linux-gnu/sys-root

FROM riscv64 AS check-riscv64

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-riscv64/ipxe.sbi \
	bin-riscv64-efi/snponly.efi bin-riscv64-efi/ipxe.iso \
	bin-riscv64-linux/tests.linux && \
    qemu-riscv64 /ipxe/src/bin-riscv64-linux/tests.linux

#
# riscv32 toolchain
#

FROM riscv64 AS riscv32

COPY --from=ghcr.io/ipxe/sysroot-riscv32 / /usr/riscv32-linux-gnu/sys-root/

ENV CROSS_COMPILE_riscv32=riscv64-linux-gnu-

ENV SYSROOT_riscv32=/usr/riscv32-linux-gnu/sys-root

ENV QEMU_LD_PREFIX=/usr/riscv32-linux-gnu/sys-root

FROM riscv32 AS check-riscv32

ARG JOBS
ENV JOBS=${JOBS}

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD make -C /ipxe/src -j ${JOBS} \
	bin-riscv32/ipxe.sbi \
	bin-riscv32-efi/snponly.efi bin-riscv32-efi/ipxe.iso \
	bin-riscv32-linux/tests.linux && \
    qemu-riscv32 /ipxe/src/bin-riscv32-linux/tests.linux

#
# Specify the default target
#

FROM x86_64 AS default
