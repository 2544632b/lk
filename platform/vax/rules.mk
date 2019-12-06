LOCAL_DIR := $(GET_LOCAL_DIR)

MODULE := $(LOCAL_DIR)

ARCH := vax

#MODULE_DEPS := \
	lib/bio \
	lib/cbuf \
	lib/watchdog \
	dev/cache/pl310 \
	dev/interrupt/arm_gic \
	dev/timer/arm_cortex_a9

MODULE_SRCS += \
	$(LOCAL_DIR)/console.c \
	$(LOCAL_DIR)/init.c \
	$(LOCAL_DIR)/rom.S \
	$(LOCAL_DIR)/timer.c \

#	$(LOCAL_DIR)/clocks.c \
	$(LOCAL_DIR)/debug.c \
	$(LOCAL_DIR)/fpga.c \
	$(LOCAL_DIR)/gpio.c \
	$(LOCAL_DIR)/platform.c \
	$(LOCAL_DIR)/qspi.c \
	$(LOCAL_DIR)/spiflash.c \
	$(LOCAL_DIR)/start.S \
	$(LOCAL_DIR)/swdt.c \
	$(LOCAL_DIR)/uart.c \

MEMBASE := 0x00000000
MEMSIZE ?= 0x00800000 # default to 8MB
KERNEL_LOAD_OFFSET := 0x00100000 # loaded 1MB into physical space

# put our kernel at 0x80000000 once we get the mmu running
#KERNEL_BASE = 0x80000000
KERNEL_BASE = 0

# tool to add a mop header to the output binary to be net bootable
MKMOPHEADER := $(call TOBUILDDIR,$(LOCAL_DIR)/mkmopheader)
$(MKMOPHEADER): $(LOCAL_DIR)/mkmopheader.c
	@$(MKDIR)
	$(NOECHO)echo compiling host tool $@; \
	cc -O -Wall $< -o $@

GENERATED += $(MKMOPHEADER)

$(OUTBIN).mop: $(MKMOPHEADER) $(OUTBIN)
	@$(MKDIR)
	$(NOECHO)echo generating $@; \
	$(MKMOPHEADER) $(OUTBIN) $@

EXTRA_BUILDDEPS += $(OUTBIN).mop
GENERATED += $(OUTBIN).mop

include make/module.mk
