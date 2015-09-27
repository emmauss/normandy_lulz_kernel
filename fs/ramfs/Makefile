#
# Makefile for the linux ramfs routines.
#

KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa, -Wno-incompatible-pointer-types $(LIN_FLAG))
KBUILD_CFLAGS	:=$(KBUILD_CFLAGS:-msoft-float=-Wa, -Wno-incompatible-pointer-types $(LIN_FLAG))

obj-y += ramfs.o

file-mmu-y := file-nommu.o
file-mmu-$(CONFIG_MMU) := file-mmu.o
ramfs-objs += inode.o $(file-mmu-y)
