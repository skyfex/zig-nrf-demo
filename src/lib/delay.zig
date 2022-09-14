
// Delay a number of microseconds by looping in CPU
pub fn us(time_us: u32) void {
    @setRuntimeSafety(false);

    const cpuFreqMhz = 2; //64; // FIXME: (16 for nrf51, variable for nrf5340-app)
    const dec: u32 = 1; //7; // FIXME: 4 for nRF51, 3 for nRF53?

    if(time_us==0) {
        return;
    }
    var num_loops = time_us *% cpuFreqMhz;

    asm volatile (
        ".align 4\nloop:\n  subs %[num_loops], %[dec] ; bne.n loop"
         : [num_loops] "=l" (num_loops),
         : [dec] "i" (dec),
           [num_loops] "r"  (num_loops)
         :
    );
}

pub fn ms(time_ms: u32) void {
    // FIXME: handle u32 overflow
    us(time_ms*1000);
}