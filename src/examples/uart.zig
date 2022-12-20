usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");

pub fn main() void {
    board.init();
    board.led1.on();
    lib.uart.init(board.uart1_rts, board.uart1_txd, board.uart1_cts, board.uart1_rxd);
    board.led2.on();
    lib.uart.sendString("Testing\n");
    board.led3.on();
}
