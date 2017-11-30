zig build-obj --target-os freestanding --target-arch thumb --assembly gcc_startup_nrf51.S test.zig
arm-none-eabi-gcc -mthumb -mabi=aapcs "-Tnrf51_xxaa.ld" -mcpu=cortex-m0 -nostdlib .\zig-cache\test.o -o test.out 
arm-none-eabi-objcopy -O ihex test.out test.hex
