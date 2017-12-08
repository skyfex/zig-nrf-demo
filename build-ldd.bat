REM arm-none-eabi-gcc -std=c99 -x assembler-with-cpp -c -o gcc_startup_nrf51.S.o gcc_startup_nrf51.S

zig build-obj --target-os freestanding --target-arch thumb --assembly gcc_startup_nrf51.S -isystem include --libc-include-dir include test.zig
ld.lld -T nrf51_xxaa.ld -m armelf_linux_eabi -nostdlib -Bstatic -o test.out .\zig-cache\test.o
arm-none-eabi-objcopy -O ihex test.out test.ldd.hex
arm-none-eabi-objcopy -O binary test.out test.ldd.bin
REM copy test.hex D:\
