REM arm-none-eabi-gcc -std=c99 -x assembler-with-cpp -c -o gcc_startup_nrf51.S.o gcc_startup_nrf51.S
zig build-exe --static --target-os freestanding --target-arch thumb --target-environ eabihf --linker-script nrf51_xxaa.ld --verbose-link --assembly gcc_startup_nrf51.S test.zig
arm-none-eabi-objcopy -O ihex test.out test.hex
