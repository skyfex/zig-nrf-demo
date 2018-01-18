
const hsv = @import("hsv.zig");
const fmt = @import("std").fmt;
const nrfZig = @import("nrf.zig");

// Import header files with NRF51 register specs
const nrf = @cImport({
    @cDefine("__SOFTFP__", "1");
    @cDefine("__GNUC__", "4");
    @cDefine("NRF52", "");
    @cInclude("nrf.h");
});

const nrfGpio = nrf.NRF_GPIO;
const nrfPwm = nrf.NRF_PWM0;
const nrfUart = nrf.NRF_UART0;


// -- Zig Panic Handler --

pub fn panic(msg: []const u8) -> noreturn { 

    nrfGpio.PIN_CNF[11] = 3;

    while (true) {

        nrfGpio.OUTSET = (1<<11);
        nrfDelayUs(100*1000);

        nrfGpio.OUTCLR = (1<<11);
        nrfDelayUs(100*1000);
    }
}

// Delay a number of microseconds by looping in CPU
fn nrfDelayUs(number_of_us: u32) {

    const clock16MHz: u32 = 16000000;
    if(number_of_us==0) {
        return;
    }

    // TODO: Assembly for adjusting delay according to SystemCoreClock (set by system_nrf51.c)
    // TODO: Generate more/less NOPs depending on NRF51/NRF52
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

const neoPin = 30;

inline fn neoPixelSendOne() -> void {
    @setDebugSafety(this, false);
    nrfGpio.OUTSET = (1 << neoPin);
    comptime var i = 0;
    inline while (i < 44) : (i += 1) {
        asm volatile("NOP");
    }
    nrfGpio.OUTCLR = (1 << neoPin);
    inline while (i < 38) : (i += 1) {
        asm volatile("NOP");
    }
} 

inline fn neoPixelSendZero() -> void {
    @setDebugSafety(this, false);
    nrfGpio.OUTSET = (1 << neoPin);
    comptime var i = 0;
    inline while (i < 22) : (i += 1) {
        asm volatile("NOP");
    }
    nrfGpio.OUTCLR = (1 << neoPin);
    inline while (i < 38) : (i += 1) {
        asm volatile("NOP");
    }
}

fn neoPixelShow(strip: [][3]u8) -> void {
    nrfGpio.OUTCLR = (1<<neoPin);
    nrfDelayUs(50);
    for (strip) |grb| {
        for (grb) |c| {
            // comptime var i = 7;
            // while (i >= 0) : (i -= 1) {

            // }
            if ((c & 128) > 0)  {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 64) > 0)   {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 32) > 0)   {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 16) > 0)   {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 8) > 0)    {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 4) > 0)    {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 2) > 0)    {neoPixelSendOne();}
            else    {neoPixelSendZero();}
            
            if ((c & 1) > 0)    {neoPixelSendOne();}
            else    {neoPixelSendZero();}            
        }
    }
}

fn neoPixelClear(strip: [][3]u8) -> void {
    for (strip) |*c| {
        *c = []u8{0,0,0};
    }
}

const sin = []u8{
            0x80,0x8c,0x98,0xa5,0xb0,0xbc,0xc6,0xd0,
            0xda,0xe2,0xea,0xf0,0xf5,0xfa,0xfd,0xfe,
            0xff,0xfe,0xfd,0xfa,0xf5,0xf0,0xea,0xe2,
            0xda,0xd0,0xc6,0xbc,0xb0,0xa5,0x98,0x8c,
            0x80,0x73,0x67,0x5a,0x4f,0x43,0x39,0x2f,
            0x25,0x1d,0x15,0xf,0xa,0x5,0x2,0x1,
            0x0,0x1,0x2,0x5,0xa,0xf,0x15,0x1d,
            0x25,0x2f,0x39,0x43,0x4f,0x5a,0x67,0x73};

const tri = []u8{
    0x8,0x10,0x18,0x20,0x28,0x30,0x38,0x40,
    0x48,0x50,0x58,0x60,0x68,0x70,0x78,0x80,
    0x87,0x8f,0x97,0x9f,0xa7,0xaf,0xb7,0xbf,
    0xc7,0xcf,0xd7,0xdf,0xe7,0xef,0xf7,0xff,
    0xf7,0xef,0xe7,0xdf,0xd7,0xcf,0xc7,0xbf,
    0xb7,0xaf,0xa7,0x9f,0x97,0x8f,0x87,0x80,
    0x78,0x70,0x68,0x60,0x58,0x50,0x48,0x40,
    0x38,0x30,0x28,0x20,0x18,0x10,0x8,0x0
};

const bufSize = 256;

var buf: [2][bufSize]u16 = undefined;
var pwmBuf: u32 = 0;
var genBuf: u32 = 0;
var genBufPtr: u32 = 0;

const sampleRate = 31250;
var t: u32 = 0;

fn pushSample(s: u16) {
    while (genBufPtr >= bufSize) {
        // Wait for IRQ
    }
    buf[genBuf][genBufPtr] = s;
    genBufPtr += 1;
    // buf[genBuf][genBufPtr] = s | (1<<15);
    // genBufPtr += 1;
    t += 1;
}

export fn PWM0_IRQHandler() {
    if (nrfPwm.EVENTS_LOOPSDONE != 0) {
        nrfPwm.EVENTS_LOOPSDONE = 0;
        if (pwmBuf == 0) {
            nrfPwm.SHORTS = (1<<2); // Loopsdone -> seqstart0
            pwmBuf = 1;
            genBuf = 0;
            genBufPtr = 0;
        }
        else if (pwmBuf == 1) {
            nrfPwm.SHORTS = (1<<3); // Loopsdone -> seqstart1
            pwmBuf = 0;
            genBuf = 1;
            genBufPtr = 0;
        }
    }
    // if (nrfPwm.EVENTS_SEQEND[0] != 0) {
    //     nrfPwm.EVENTS_SEQEND[0] = 0;
    //     nrfPwm.SHORTS = (1<<2); // Loopsdone -> seqstart0
    //     // curBuf = &buf1[0];
    //     // bufPtr = 0;
    // }
    // if (nrfPwm.EVENTS_SEQEND[1] != 0) {
    //     nrfPwm.EVENTS_SEQEND[1] = 0;
    //     nrfPwm.SHORTS = (1<<3); // Loopsdone -> seqstart1
    //     // curBuf = &buf0[0];
    //     // bufPtr = 0;
    // }
    nrfGpio.OUT = nrfGpio.OUT ^ (1<<11);
}

// -- Main --
export fn main() -> void {

    nrfGpio.PIN_CNF[11] = 3; // LED
    nrfGpio.PIN_CNF[28] = 3; // Speaker
    nrfGpio.PIN_CNF[29] = 3; // Speaker
    nrfGpio.PIN_CNF[neoPin] = 3; // NeoPixel
    nrfGpio.OUTSET = (1<<11);


    // Silence speaker
    nrfGpio.OUTCLR = (1<<28);
    nrfGpio.OUTCLR = (1<<29);

    var bla = nrfZig.PinCnfDir.Input;

    var ctr: u32 = 0;

    while (true) {

        nrfGpio.OUTSET = (1<<11);
        nrfDelayUs(50000);

        nrfGpio.OUTCLR = (1<<11);
        nrfDelayUs(50000);
        
        ctr += 1;
        if (ctr == 10) {
            break;
        }
    }

    // nrfPwm.PSEL.OUT[0] = (0<<31) | 28;
    nrfPwm.PSEL.OUT[0] = (0<<31) | 29;

    nrfPwm.ENABLE = 1;
    nrfPwm.PRESCALER = 1; // Divide by 2 / 8MHz
    nrfPwm.COUNTERTOP = 256; // 31.25kHz
    nrfPwm.MODE = 0; // Up counter
    nrfPwm.DECODER = 0; // Grouped, Refresh
    nrfPwm.LOOP = 1;


    nrfPwm.SEQ[0].PTR = @ptrToInt(&buf[0][0]);
    nrfPwm.SEQ[0].CNT =  64;
    nrfPwm.SEQ[0].REFRESH = 0;
    nrfPwm.SEQ[0].ENDDELAY = 0;

    nrfPwm.SEQ[1].PTR = @ptrToInt(&buf[1][0]);
    nrfPwm.SEQ[1].CNT =  64;
    nrfPwm.SEQ[1].REFRESH = 0;
    nrfPwm.SEQ[1].ENDDELAY = 0;

    nrfPwm.INTEN = 0;
    nrfPwm.EVENTS_LOOPSDONE = 0;
    nrfPwm.EVENTS_SEQEND[0] = 0;
    nrfPwm.EVENTS_SEQEND[1] = 0;
    nrfPwm.EVENTS_STOPPED = 0;
    nrfZig.EnableIRQ(nrf.PWM0_IRQn);

    nrfPwm.INTENSET = (1<<7); //(1<<4) | (1<<5);

    nrfPwm.SHORTS = (1<<3); // Loopsdone -> seqstart1

    pwmBuf = 0;
    genBuf = 1;

    for (buf) |*bufSlice| {
        for (*bufSlice) |*word| {
            *word = 0;
        }
    }

    nrfPwm.TASKS_SEQSTART[0] = 1;


    while (t < sampleRate*2) {
        var smp = sin[t%64];
        pushSample(smp);
    }

    t = 0;
    while (t < sampleRate*2) {
        var smp = sin[(t*2)%64];
        pushSample(smp);
    }

    nrfPwm.ENABLE = 0;

    // Silence speaker
    nrfGpio.OUTCLR = (1<<28);
    nrfGpio.OUTCLR = (1<<29);

    var h: hsv.HsvColor = undefined;

    const numLeds = 24;
    var strip: [numLeds][3]u8 = undefined;

    neoPixelClear(strip[0..]);

    nrfGpio.OUTCLR = (1<<11);

    ctr = 0;
    while (ctr < 30) : (ctr += 1) {
        for (strip) |*c, i| {
            var hc = hsv.HsvToRgb(hsv.HsvColor{ 
                    .h = u8(((i+ctr)*10) % 256), 
                    .s = 240, 
                    .v = 128});
            (*c)[0] = hc.g;
            (*c)[1] = hc.r;
            (*c)[2] = hc.b;
        }

        neoPixelShow(strip[0..]);

        nrfDelayUs(40*1000);
    }

    neoPixelClear(strip[0..]);
    neoPixelShow(strip[0..]);

    nrfPwm.ENABLE = 0;

    while (true) {

    }


}

// TODO: Remove when compiler-rt is updated

export fn __muldi3(a: u64, b: u64) -> u64 {
    @setDebugSafety(this, false);
    var as: u64 = a;
    var bs: u64 = b;
    var res: u64 = 0;
    while (bs != 0) {
        if (bs & 1 != 0) {
            res += as;
        }
        bs >>= 1;
        as <<= 1;
    }
    return res;
}