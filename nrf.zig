
pub const u1 = @IntType(false, 1);
const u14 = @IntType(false, 14);

pub const PinCnfDir = enum (u1) {
    Input,
    Output
};

pub const PinCnfInput = enum (u1) {
    Connect,
    Disconnect
};

pub const PinCnfPull = enum (u2) {
    Disabled = 0,
    Pulldown = 1,
    Pullup = 3
};

pub const PinCnfDrive = enum (u3) {
    S0S1 = 0,
    H0S1 = 1,
    S0H1 = 2,
    H0H1 = 3,
    D0S1 = 4,
    D0H1 = 5,
    S0D1 = 6,
    H0D1 = 7,
};

pub const PinCnfSense = enum (u2) {
    Disabled = 0,
    High = 2,
    Low = 3
};

pub const PinCnf = packed struct {
    dir: PinCnfDir,
    input: PinCnfInput,
    pull: PinCnfPull,
    _reserved1: u4,
    drive: PinCnfDrive,
    _reserved3: u5,
    sense: PinCnfSense,
    _reserved4: u14
};


// -- Port of utility functions from ARM CMSIS --

inline fn WFI() {
    asm volatile (
        \\ .arch armv6-m
        \\ WFI
        );
}

pub fn EnableIRQ(IRQn: c_int) {
    // Get pointer to NVIC ISER register
    const ISER = @intToPtr(&u32, 0xE000E000 + 0x0100 + 0x0);
    var v = (u32(1) << u5(u32(IRQn) & 0x1F));  
    ISER[usize(IRQn) >> 5] = v;
}

pub fn DisableIRQ(IRQn: c_int) {
    // Get pointer to NVIC ICER register
    const ICER = @intToPtr(&u32, 0xE000E000 + 0x0100 + 0x080);
    *ICER = (u32(1) << u5(IRQn));
}  

