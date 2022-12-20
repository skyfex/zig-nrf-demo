
pub fn enable(irq_num: u32) void {
    // Get pointer to NVIC ISER register
    const ISER = @intToPtr(*u32, 0xE000E000 + 0x0100 + 0x0);
    ISER.* = @as(u32,1) << @intCast(u5, irq_num);
}

pub fn disable(irq_num: u32) void {
    // Get pointer to NVIC ICER register
    const ICER = @intToPtr(*u32, 0xE000E000 + 0x0100 + 0x080);
    ICER.* = @as(u32,1) << @intCast(u5, irq_num);
}  
