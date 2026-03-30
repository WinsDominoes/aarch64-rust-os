# Makefile: Compile the boot assembly, builds the rust kernel as a staticlib
# links them into an ELF binary using rust-lld

## DECLARE SOME ENVIRONMENTS

# Target arch & toolchain
TARGET := aarch64-unknown-none
AS := aarch64-linux-gnu-as ## ASSEMBLER
CC := aarch64-linux-gnu-gcc-14
CFLAGS := -Wall -ggdb -ffreestanding -nostdlib -I./include
LD := rust-lld
QEMU := qemu-system-aarch64
VERSION := debug

# File paths
SRC_DIR := src
ASM_DIR := $(SRC_DIR)/asm
BOOT_ASM := $(ASM_DIR)/boot.s
KERNEL_RS := $(SRC_DIR)/lib.rs
LINKER_SCRIPT := linker.ld

# oOutput filenames
BOOT_OBJ := $(ASM_DIR)/boot.o
CRATE_NAME := $(shell cargo metadata --no-deps --format-version 1 | jq -r '.packages[0].name')
KERNEL_OBJ := target/$(TARGET)/$(VERSION)/lib$(CRATE_NAME).a
KERNEL_ELF := kernel.elf

# QEMU options - vm bullshit
QEMU_FLAGS := -machine virt -cpu cortex-a57 -nographic -kernel $(KERNEL_ELF)

### SECTION THAT BUILDS THE THING ITSELF

# build kernel
all: $(KERNEL_ELF)

# Assembly the boot.s -> boot.o
$(BOOT_OBJ): $(BOOT_ASM)
	$(AS) $< -o $@

# Compile the Rust kernel -> obj file
$(KERNEL_OBJ): $(KERNEL_RS) 			## entry
	cargo build --target $(TARGET) 

# Link kernel object & boot object -> ELF
$(KERNEL_ELF): $(BOOT_OBJ) $(KERNEL_OBJ) $(LINKER_SCRIPT)
	$(LD) -flavor gnu -o $(KERNEL_ELF) -T $(LINKER_SCRIPT) -o $@ $(BOOT_OBJ) $(KERNEL_OBJ)

# Run kernel with QEMU
run: $(KERNEL_ELF)
	$(QEMU) $(QEMU_FLAGS)

# Clean up bullshit archifacts
# for when you want to build everything again, lmao
clean:
	cargo clean
	rm -rf target
	rm -f $(BOOT_OBJ) $(KERNEL_ELF)

.PHONY: all run clean