TOPDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ARCHS := $(patsubst configs/%_defconfig,%,$(wildcard configs/*_defconfig))

all : $(ARCHS)

clean :
	$(RM) -rf $(TOPDIR)/output

sysroot_%_defconfig : $(TOPDIR)/configs/sysroot_%_defconfig
	$(MAKE) -C $(TOPDIR)/buildroot BR2_EXTERNAL=$(TOPDIR) \
		O=$(TOPDIR)/output/$* $@

% : sysroot_%_defconfig
	$(MAKE) -C $(TOPDIR)/output/$@
