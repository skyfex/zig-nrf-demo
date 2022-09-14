
usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");

const delay = lib.delay;

fn func() u32 {
    // 2
    board.led2.on();
    delay.us(300_0000);
    // 3
    suspend {}
    // 6
    board.led4.on();
    delay.us(300_0000);
    // 7
    suspend {}
    // 10
    board.led3.off();
    delay.us(300_0000);
    return 42;
}

pub fn main() void {

    board.init();

    board.led1.on();
    delay.us(300_0000);
    // 1
    var frame = async func();
    // 4
    board.led3.on();
    delay.us(300_0000);
    // 5
    resume frame;
    // 8
    board.led4.off();
    delay.us(300_0000);
    // 9
    resume frame;
    // 11
    board.led2.off();
    delay.us(300_0000);
    // 12
    var res = await frame;
    // 13
    if (res == 42) {
        board.led1.off();
        delay.us(300_0000);
    }

    for (board.leds) |led| { led.on(); }
    delay.us(300_0000);
    for (board.leds) |led| { led.off(); }
    delay.us(300_0000);
    for (board.leds) |led| { led.on(); }
}
