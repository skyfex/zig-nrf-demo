# zig-nrf-demo
Demonstrate Zig code on the nRF51/nRF52 microcontrollers

This demo is currently using the BBC micro:bit. Build-scripts made for windows, but they are just a list of commands, so should work with little/no modification on other OSs.

## Goals
* - Build binary with just Zig, startup assembly and link scripts
* ✓ Import/use C header files from SDK
* X Map registers to structs with bit fields
* ✓ Blink LEDs
* ✓ Print over UART
* X Use std.fmt with UART
* ✓ Handle interrupts
* X Read buttons
* ✓ Implement delay functions (inline assembly)
* X Use timers
* X Maybe: Find a good use-case for compile-time/generics
* X Maybe: Read micro:bit accelerometer/compass over I2C
* X Maybe: Send/receive packets over radio
* X Maybe: Use Zig build system
* X Maybe: Stack trace

## Status
* Linking does not work properly with Zig (does work now with LLD though)
* Placement of bit fields in struct in not correct (for little-endian)
* No option for selecting soft/hard float, link issues related to float and zig stdlib
