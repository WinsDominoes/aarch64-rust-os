# aarch64-rust-os
I want to do something absolutely crazy at the age of 18 years of age and no one can stop me. 

## RUN
1. Instal this bullshit
```bash
sudo apt update && sudo apt upgrade
# QEMU for emulation
sudo apt install qemu-system-aarch64
# Binutils (objdump, etc.)
sudo apt install binutils-aarch64-linux-gnu
# Cross-compiler
sudo apt install gcc-14-aarch64-linux-gnu
```
2. Install Rust & aarch64 bare-metal target (This lets us compile Rust code for a freestanding, no-OS environment.)
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup target add aarch64-unknown-none
```
3. Run `make run`

## Timeline of my craziness
- 30/3/2026

sooo... I have to create a bunch of files like assembly and such. I have to use another Rust distrobox

wehat the hell is a segment and section

Segment - talking w/ OS - piece of information that is needed at runtime
Section - info for linking

Particularly important informations are (besides lengths):

### Section vs Segments in ELF
- Sections for linking and Segments for Execution

Sections:
> Sections are a way to organise the binary into logical areas to communicate information between the compiler and the linker.

Linker.ld tells to linker how the memory is laid out in this ELF. 

#### section: tell the linker if a section is either:
- raw data to be loaded into memory, e.g. .data, .text, etc.
- or formatted metadata about other sections, that will be used by the linker, but disappear at runtime e.g. .symtab, .srttab, .rela.text

#### segment: tells the operating system:
- where should a segment be loaded into virtual memory
- what permissions the segments have (read, write, execute). Remember that this can be efficiently enforced by the processor: How does x86 paging work?

Ref: [https://stackoverflow.com/questions/14361248/whats-the-difference-of-section-and-segment-in-elf-file-format](https://stackoverflow.com/questions/14361248/whats-the-difference-of-section-and-segment-in-elf-file-format)

Makefile - build everything jingle bells

`boot.s` -> assembly file -> first code that runs when kernel is loaded -> set up stack and jump -> Rust code 
```asm
.section .text
.global _start

_start:
    ldr x30, =stack_top ;; x30 -> Link Register of ARM64 arch. 
                        ;; link register -> used for storing the return address of a subroutine or function call
    mov sp, x30         ;; mov value x30 -> sp (stack pointer) points to the stop of the stack
                        ;; to show where in the stack we currently are (in the memory)
    bl kmain()          ;; bl -> call kmain()
    b .                 ;; go to . (LABEL)
```

`lib.rs` -> kernel that talks directly to the UART at address 0x0900_0000, which QEMU maps to a PL011 UART on the virt machine.

#### UART???
> SPI and UART are both types of interfaces. UART (Universal Asynchronous Receiver Transmitter) means just that, it’s a generic interface for transferring information in one, or two directions, asynchronously (i.e. no clock is transferred across the interface). - [Reddit](https://www.reddit.com/r/embedded/comments/oxrkh4/precisely_what_is_uartusartand_spi/)

### rust-lld issue (in the Makefile)
Use `ld.lld` and set the filename properly. [https://github.com/krinkinmu/aarch64/blob/master/Makefile](https://github.com/krinkinmu/aarch64/blob/master/Makefile)

## References
- [From Scratch: An AArch64 OS in Rust - Hello World - https://jcomes.org/aarch64-os-hello_world](https://jcomes.org/aarch64-os-hello_world)
- [Basic ARM64 Assembly Guide - https://www.rose-hulman.edu/class/csse/csse132/2526c/ARM_cheatsheet.pdf](https://www.rose-hulman.edu/class/csse/csse132/2526c/ARM_cheatsheet.pdf)
- [General Register ARM64 diagram - https://miro.medium.com/v2/1*Fs-PmlRPoMIJ22p0737F9Q.png](https://miro.medium.com/v2/1*Fs-PmlRPoMIJ22p0737F9Q.png)
- [ARMv8-AArch64 Registers and Instruction Set- https://en.eeworld.com.cn/news/mcu/eic555596.html](https://en.eeworld.com.cn/news/mcu/eic555596.html)
- [Registers of the ARM64 Register Architecture](https://eclecticlight.co/wp-content/uploads/2021/06/armregisterarch.pdf)
- [Code in ARM Assembly: Registers explained - https://eclecticlight.co/2021/06/16/code-in-arm-assembly-registers-explained/](https://eclecticlight.co/2021/06/16/code-in-arm-assembly-registers-explained/)
- [Adding a little bit of Rust to AARCH64 - https://krinkinmu.github.io/2020/12/13/adding-rust-to-aarch64.html](https://krinkinmu.github.io/2020/12/13/adding-rust-to-aarch64.html)
- [krinkinmu/arch64](https://github.com/krinkinmu/aarch64)
- [Memory Management - OSDevWiki](https://wiki.osdev.org/Memory_management)
- [QEMU AArch64 Virt Bare Bones - https://wiki.osdev.org/QEMU_AArch64_Virt_Bare_Bones](https://wiki.osdev.org/QEMU_AArch64_Virt_Bare_Bones)
- [ELF Format Diagram - Wikipedia Media](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format#/media/File:Elf-layout--en.svg)
- [Understanding ELF File Layout in Memory - https://chessman7.substack.com/p/understanding-elf-file-layout-in](https://chessman7.substack.com/p/understanding-elf-file-layout-in)
- [ELF - Bottom UPCS](https://bottomupcs.com/ch08s03.html)
- [What's the difference of section and segment in ELF file format](https://stackoverflow.com/questions/14361248/whats-the-difference-of-section-and-segment-in-elf-file-format)
- [cirosantilli/notes - Section vs segment](https://github.com/cirosantilli/notes/blob/master/stack-overflow/section-vs-segment.md)
- [Precisely, what is UART/USART (and SPI?)](https://www.reddit.com/r/embedded/comments/oxrkh4/precisely_what_is_uartusartand_spi/)
- [UART: A Hardware Communication Protocol Understanding Universal Asynchronous Receiver/Transmitter](https://www.analog.com/en/resources/analog-dialogue/articles/uart-a-hardware-communication-protocol.html)
- [Universal asynchronous receiver-transmitter - Wikipedia](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)