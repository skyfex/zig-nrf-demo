
usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");

pub fn main() void {
    board.init();
    board.led1.on();
    lib.delay.ms(1000);
    board.led2.on();
    lib.delay.ms(1000);
    board.led3.on();
    lib.delay.ms(1000);
    board.led4.on();
}
