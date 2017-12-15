REM arm-none-eabi-gcc -std=c99 -x assembler-with-cpp -c -o gcc_startup_nrf51.S.o gcc_startup_nrf51.S
zig build-exe --static --target-os freestanding --target-arch thumb --target-environ eabihf  --libc-include-dir include --linker-script nrf51_xxaa.ld --verbose-link --assembly gcc_startup_nrf51.S test.zig
ld.lld -T nrf51_xxaa.ld -m armelf_linux_eabi  -Bstatic -o test.out .\zig-cache\test.o .\zig-cache\builtin.o

REM arm-none-eabi-objcopy -O ihex test.out test.hex
