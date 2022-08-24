# zig-nrf-demo
Demonstrate Zig code on the nRF51/nRF52/nRF53 microcontrollers

This demo is currently using the BBC micro:bit.

## Goals
* (X) Build binary with just Zig, startup assembly and link scripts
* (✓) Import/use C header files from SDK
* (X) Map registers to structs with bit fields
* (✓) Blink LEDs
* (✓) Print over UART
* (✓) Use std.fmt with UART
* (✓) Handle interrupts
* (X) Read buttons
* (✓) Implement delay functions (inline assembly)
* (X) Use timers
* (X) Maybe: Find a good use-case for compile-time/generics
* (X) Maybe: Read micro:bit accelerometer/compass over I2C
* (X) Maybe: Send/receive packets over radio
* (X) Maybe: Use Zig build system
* (X) Maybe: Stack trace

## Status
* Missing functions from compiler_rt needs workaround
