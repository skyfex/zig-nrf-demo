# zig-nrf-demo
Demonstrate Zig code on the nRF51/nRF52/nRF53 microcontrollers

## Supported Boards

* PCA10040 - nRF52832 DK
* PCA10056 - nrf52840 DK
* PCA10095 - nrf5340 DK
* micro_bit  - micro:bit
* micro_bit_v2 - micro:bit v2

## Goals
* (✓) Build binary with just Zig, startup assembly and link scripts
* (✓) Use Zig build system
* (✓) Import/use C header files from MDK
* (✓) Map registers to structs with bit fields
* (✓) Blink LEDs
* (✓) Print over UART
* (✓) Use std.fmt with UART
* (✓) Handle interrupts
* (✓) Implement delay functions (inline assembly)
* (✓) Use timers
* (✓) Show usecase for async/await
* (X) Read buttons
* (X) Show a good use-case for compile-time/generics
* (X) Read micro:bit accelerometer/compass over I2C
* (X) Send/receive packets over radio
* (X) Stack trace
