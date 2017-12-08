# zig-nrf-demo
Demonstrate Zig code on the nRF51/nRF52 microcontrollers

This demo is currently using the BBC micro:bit

## Goals
* Build binary with just Zig, startup assembly and link scripts
* Map registers to structs
* Blink LEDs
* Print over UART
* Read buttons
* Maybe: read micro:bit accelerometer/compass over I2C

## Status
* Linking does not work properly with Zig (does work now with LLD though)
* Placement of bit fields in struct in not correct (for little-endian)
* No option for selecting soft/hard float
