# aarch64-rust-os
I want to do something absolutely crazy at the age of 18 years of age and no one can stop me. 

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