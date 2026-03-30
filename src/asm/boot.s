.section .text
.global _start

_start:
    ldr x30, =stack_top ;; x30 -> Link Register of ARM64 arch. 
                        ;; link register -> used for storing the return address of a subroutine or function call
    mov sp, x30         ;; mov value x30 -> sp (stack pointer) points to the stop of the stack
                        ;; to show where in the stack we currently are (in the memory)
    bl kmain()          ;; bl -> call kmain()
    b .                 ;; go to . (LABEL)