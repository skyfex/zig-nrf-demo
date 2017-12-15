
REM Build Zig compiler-rt
zig build-obj --release-fast --target-os freestanding --target-arch thumb ../lib/zig/std/special/compiler_rt/index.zig --name compiler_rt
REM Build Zig custom builtin / stdlib replacement
zig build-obj --release-fast --target-os freestanding --target-arch thumb mybuiltin.zig
REM Build Zig code and NRF51 startup assembly
zig build-obj --target-os freestanding --target-arch thumb --assembly gcc_startup_nrf51.S -isystem include --libc-include-dir include test.zig
REM Build nrf51 system init code, C code from NRF SDK with workaround for chip bugs etc.
arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -mabi=aapcs -Wall -Werror -O3 -g3 -mfloat-abi=soft -ffunction-sections -fdata-sections -fno-strict-aliasing -fno-builtin --short-enums -DNRF51 -Iinclude -c system/system_nrf51.c -o zig-cache/system_nrf51.o
REM Link with LDD
ld.lld -T nrf51_xxaa.ld -m armelf_linux_eabi  -Bstatic -o test.out .\zig-cache\compiler_rt.o .\zig-cache\system_nrf51.o .\zig-cache\test.o .\zig-cache\mybuiltin.o
REM Generate .hex and .bin
arm-none-eabi-objcopy -O ihex test.out test.ldd.hex
arm-none-eabi-objcopy -O binary test.out test.ldd.bin
REM copy test.hex D:\
