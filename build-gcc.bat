REM arm-none-eabi-gcc -std=c99 -x assembler-with-cpp -c -o gcc_startup_nrf51.S.o gcc_startup_nrf51.S

zig build-obj --target-os freestanding --target-arch thumb --assembly gcc_startup_nrf51.S test.zig
arm-none-eabi-gcc -mthumb -mabi=aapcs "-Tnrf51_xxaa.ld" -mcpu=cortex-m0 -nostdlib .\zig-cache\test.o -o test.out 
REM ld.lld -T nrf51_xxaa.ld -m armelf_linux_eabi -nostdlib -Bstatic -o test.out .\zig-cache\test.o
arm-none-eabi-objcopy -O ihex test.out test.gcc.hex
arm-none-eabi-objcopy -O binary test.out test.gcc.bin
REM copy test.hex D:\
