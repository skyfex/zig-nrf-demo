
const u1 = @IntType(false, 1);
const u14 = @IntType(false, 14);

const PinCnf = packed struct {
    dir: u1,
    input: u1,
    pull: u2,
    _reserved1: u4,
    // foobar: u4,
    drive: u3,
    _reserved3: u5,
    sense: u2,
    _reserved4: u14
    // foobar: u32
};

export fn SystemInit() -> void {
    
}

export fn main() -> void {
    const pin_cnf4 = @intToPtr(&PinCnf, 0x50000710);
    const pin_cnf8 = @intToPtr(&i32, 0x50000700+8*4);
    const pin_cnf13 = @intToPtr(&i32, 0x50000734);
    const pin_out4 = @intToPtr(&i32, 0x50000620);
    const pin_out8 = @intToPtr(&i32, 0x50000600+8*4*2);
    const pin_out13 = @intToPtr(&i32, 0x50000668);
    pin_cnf4.dir = 1;
    pin_cnf4.input = 1;
    // pin_cnf4.foobar = 7;
    *pin_cnf8 = 3;
    *pin_cnf13 = 3;
    *pin_out4 = 0;
    *pin_out8 = 0;
    *pin_out13 = 1;
}