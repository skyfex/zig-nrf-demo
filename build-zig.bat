zig build-exe --static --target-os freestanding --target-arch thumb --target-environ eabihf --assembly gcc_startup_nrf51.S --linker-script nrf51_xxaa.ld --verbose-link test.zig  
arm-none-eabi-objcopy -O ihex test.out test.hex
