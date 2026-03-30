// Freestanding Rust
#![no_main]
#![no_std]

// Kernel -> Send a message to UART (Universal Asynchronous Receiver Transmitter ) 
// via MMIO (direct memory-mapped IO)

//  It talks directly to the UART at address 0x0900_0000, which QEMU maps to a PL011 UART on the virt machine.

use core::panic::PanicInfo;

const UART: *mut u8 = 0x0900_0000 as *mut u8; 

#[unsafe(no_mangle)]
pub extern "C" fn kmain()
{
    print(b"Hello, from Rust!\n");
}

// put character function
fn putchar(c: u8) 
{
    unsafe
    {
        *UART = c; 
    }    
}

fn print(s: &[u8])
{
    for &c in s
    {
        putchar(c);
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! 
{
    print(b"Panic!\n");
    loop {}
}