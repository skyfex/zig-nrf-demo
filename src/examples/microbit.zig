
usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");


const GPIO = nrf.GPIO;

pub fn main() void {

    board.init();

    lib.uart.init();

    board.led1.on();
    lib.delay.us(100_000);
    board.led2.on();
    lib.delay.us(100_000);
    board.led3.on();
    lib.delay.us(100_000);
    board.led4.on();
    lib.delay.us(100_000);
    board.led5.on();
    lib.delay.us(100_000);

}
