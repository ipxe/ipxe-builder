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

FROM signer AS check-signer

RUN dnf install -y \
	libcdio \
	shim-x64 \
    && dnf clean all -y

RUN ln -s /bin/true dummy.lkrn

RUN ln -s /boot/efi/EFI/BOOT/BOOTX64.EFI dummy.efi

ADD https://github.com/ipxe/ipxe.git /ipxe

CMD /ipxe/src/util/genfsimg -o dummy.iso dummy.lkrn dummy.efi && \
    iso-info dummy.iso

#
# Specify the default target
#

FROM signer AS default
