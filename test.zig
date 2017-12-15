
const fmt = @import("std").fmt;

// Import header files with NRF51 register specs
const nrf = @cImport({
    @cDefine("__SOFTFP__", "1");
    @cDefine("__GNUC__", "4");
    @cDefine("NRF51", "");
    @cInclude("nrf.h");
});

const nrfGpio = nrf.NRF_GPIO;
const nrfUart = nrf.NRF_UART0;

// -- Board configuration --
const ledCol1 = 4;
const ledCol2 = 5;
const ledCol3 = 6;
const ledCol4 = 7;
const ledCol5 = 8;
const ledCol6 = 9;
const ledCol7 = 10;
const ledCol8 = 11;
const ledCol9 = 12;

const ledRow1 = 13;
const ledRow2 = 14;
const ledRow3 = 15;

// -- Zig Panic Handler --

pub fn panic(msg: []const u8) -> noreturn { 
    // -- Show panic-pattern on LEDs --
    // Configure all LED-related GPIO as outputs
    nrfGpio.PIN_CNF[ledCol1] = 3;
    nrfGpio.PIN_CNF[ledCol2] = 3;
    nrfGpio.PIN_CNF[ledCol3] = 3;
    nrfGpio.PIN_CNF[ledCol4] = 3;
    nrfGpio.PIN_CNF[ledCol5] = 3;
    nrfGpio.PIN_CNF[ledCol6] = 3;
    nrfGpio.PIN_CNF[ledCol7] = 3;
    nrfGpio.PIN_CNF[ledCol8] = 3;
    nrfGpio.PIN_CNF[ledCol9] = 3;
    nrfGpio.PIN_CNF[ledRow1] = 3;
    nrfGpio.PIN_CNF[ledRow2] = 3;
    nrfGpio.PIN_CNF[ledRow3] = 3;

    // Turn on all led columns
    // Turn on row 2 (row 1 and 3 off)
    nrfGpio.OUT = (1 << ledRow2);


    // -- Print panic message to UART in the safest/dumbest way possible --
    NVIC_DisableIRQ(nrf.UART0_IRQn);
    nrfUart.PSELTXD = 24;
    nrfUart.BAUDRATE = nrf.UART_BAUDRATE_BAUDRATE_Baud9600;
    nrfUart.ENABLE = 4;
    nrfUart.TASKS_STARTTX = 1; 
    const prefix = "\n\nPanic!\n";
    for (prefix) |ch| {
        nrfDelayUs(2000);
        nrfUart.TXD = ch;
    }
    for (msg) |ch| {
        nrfDelayUs(2000);
        nrfUart.TXD = ch;
    }

    // -- Blink LED pattern --
    while (true) {
        nrfGpio.OUT = nrfGpio.OUT ^ (1<<ledRow2);
        nrfDelayUs(500000);
    } 
}

// -- Port of utility-functions from NRF SDK --

// TODO: This function doesn't work yet (doesn't compile in debug mode due to missing builtin)
inline fn nrfDelayMs(number_of_ms: u32) {
    nrfDelayUs(1000*number_of_ms);
}

// Delay a number of microseconds by looping in CPU
fn nrfDelayUs(number_of_us: u32) {

    const clock16MHz: u32 = 16000000;
    if(number_of_us==0) {
        return;
    }

    asm volatile (
        \\ loop:
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP
        \\     NOP 
        \\     NOP
        \\     NOP
        \\ cond:
        \\     SUBS %[number_of_us], #1
        \\     BNE.N loop
        : [number_of_us] "=l" (number_of_us),
          // [syscoreclock] "r"  (SystemCoreClock),
          // [clock16mhz]   "r"  (clock16MHz),
        :  [number_of_us] "r"  (number_of_us)
        );
// \\     CMP %[syscoreclock], %[clock16mhz]
// \\     BEQ.N cond
}

// -- Port of utility functions from ARM CMSIS --

fn NVIC_EnableIRQ(IRQn: c_int) {
    // Get pointer to NVIC ISER register
    const ISER = @intToPtr(&u32, 0xE000E000 + 0x0100 + 0x0);
    *ISER = (u32(1) << u5(IRQn));
}

fn NVIC_DisableIRQ(IRQn: c_int) {
    // Get pointer to NVIC ICER register
    const ICER = @intToPtr(&u32, 0xE000E000 + 0x0100 + 0x080);
    *ICER = (u32(1) << u5(IRQn));
}  

// -- UART Driver --

var uartBusy: bool = false;
var uartBufferPtr: &const u8 = undefined;
var uartBufferEnd: &const u8 = undefined;

fn uartInit() {
    // NVIC_SetPriority(PWM_IRQn, 2);
    NVIC_EnableIRQ(nrf.UART0_IRQn);

    uartBusy = false;

    nrfUart.INTENSET = (1<<nrf.UART_INTENSET_TXDRDY_Pos); //nrf.UART_INTENSET_TXDRDY_Msk;
    nrfUart.PSELTXD = 24;
    nrfUart.BAUDRATE = nrf.UART_BAUDRATE_BAUDRATE_Baud9600;
    nrfUart.ENABLE = nrf.UART_ENABLE_ENABLE_Enabled;
    nrfUart.TASKS_STARTTX = 1;
}

export fn UART0_IRQHandler() {
    nrfUart.EVENTS_TXDRDY = 0;
    uartSendBufferByte();
}

fn uartSendBufferByte() {
    if (@ptrToInt(uartBufferPtr) <= @ptrToInt(uartBufferEnd)) {
        nrfUart.TXD = *uartBufferPtr;
        uartBufferPtr = &uartBufferPtr[1];
    }
    else {
        uartBusy = false;
        nrfGpio.OUT = nrfGpio.OUT ^ (1<<4);
    }
}

fn uartSendString(str: []const u8) {
    while (uartBusy) {}
    uartBusy = true;
    uartBufferPtr = &str[0];
    uartBufferEnd = &str[str.len-1];

    uartSendBufferByte();
}

// -- Main --
export fn main() -> void {


    nrfGpio.PIN_CNF[4] = 3;
    nrfGpio.PIN_CNF[5] = 3;
    nrfGpio.PIN_CNF[8] = 3;
    nrfGpio.PIN_CNF[13] = 3;
    nrfGpio.PIN_CNF[14] = 3;
    nrfGpio.PIN_CNF[15] = 3;
    nrfGpio.OUTSET = (1<<13) | (1<<15);
    nrfGpio.OUTSET = (1<<5);
    nrfGpio.OUTCLR = (1<<8) | (1<<4);

    nrfGpio.PIN_CNF[24] = 3;

    uartInit();

    var ctr: u32 = 0;
    while (true) {
        const string = "Hello World from Zig!\n";
        uartSendString(string);

        var fmtBuffer: [100]u8 = undefined;
        const fmtMessage = fmt.bufPrint(fmtBuffer[0..], "Counter: {}\n", ctr);
        uartSendString(fmtMessage);

        nrfDelayUs(1000*500);
        ctr += 1;
        nrfGpio.OUT = nrfGpio.OUT ^ (1<<8);
    }
}

// TODO: Remove when compiler-rt is updated

// export fn __udivsi3(n: u32, d: u32) -> u32 {
//     @setDebugSafety(this, false);
//     if (d==0) panic("divison by zero");
//     var q: u32 = 0;
//     var r: u32 = n;
//     while (r >= d) {
//         q += 1;
//         r -= d;
//     }
//     return q
// }

// export fn __umodsi3(n: u32, d: u32) -> u32 {
//     @setDebugSafety(this, false);
//     var q: u32 = 0;
//     var r: u32 = n;
//     while (r >= d) {
//         q += 1;
//         r -= d;
//     }
//     return r
// }