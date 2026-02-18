ARG FEDORA=latest

#
# Signing toolchain
#

FROM fedora:${FEDORA} AS signer

RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf \
    && dnf update -y \
    && dnf install -y \
	opensc \
	openssl \
	openssl-pkcs11 \
	osslsigncode \
	pkcs11-provider \
    && dnf clean all -y

FROM signer AS check-signer

RUN dnf install -y \
	shim-x64 \
    && dnf clean all -y

CMD openssl req -newkey rsa:2048 -nodes -keyout test.key \
		-subj '/CN=test/' -x509 -out test.crt && \
    osslsigncode sign -certs test.crt -key test.key \
		      -in /boot/efi/EFI/BOOT/BOOTX64.EFI -out test.efi && \
    osslsigncode verify -CAfile test.crt test.efi

#
# Service container for pcscd
#

FROM signer AS pcscd

CMD rm -f /run/pcscd/pcscd.comm ; \
    /usr/bin/pcscd --foreground --disable-polkit

HEALTHCHECK --interval=3s --timeout=5s CMD pcscd --hotplug

#
# Specify the default target
#

FROM signer AS default
