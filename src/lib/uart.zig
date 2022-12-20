

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("./lib.zig");

const Pin = lib.gpio.Pin;

const uart = nrf.UART0;
var uartBusy: bool = false;
var uartBufferPtr: [*]const u8 = undefined;
var uartBufferEnd: [*]const u8 = undefined;

pub fn init(rts: Pin, txd: Pin, cts: Pin, rxd: Pin) void {

    uartBusy = false;

    rts.set_PIN_CNF(.{.DIR = .Output, .INPUT = .Disconnect});
    txd.set_PIN_CNF(.{.DIR = .Output, .INPUT = .Disconnect});
    cts.set_PIN_CNF(.{.DIR = .Input,  .INPUT = .Connect});
    rxd.set_PIN_CNF(.{.DIR = .Input,  .INPUT = .Connect});

    uart.PSEL.RTS = rts.pselValue();
    uart.PSEL.TXD = txd.pselValue();
    uart.PSEL.CTS = cts.pselValue();
    uart.PSEL.RXD = rxd.pselValue();


    lib.irq.enable(nrf.UARTEm[0].irq_num);

    uart.INTENSET      = .{.TXDRDY = 1};

    uart.BAUDRATE.set(.Baud9600);
    uart.ENABLE.set(.Enabled);
    uart.TASKS_STARTTX.trigger();
}

export fn UARTE0_UART0_IRQHandler() void {
    uart.EVENTS_TXDRDY.clear();
    // board.led2.on();
    sendBufferByte();
}

pub fn sendBufferByte() void {
    if (@ptrToInt(uartBufferPtr) <= @ptrToInt(uartBufferEnd)) {
        uart.TXD.set(uartBufferPtr[0]);
        uartBufferPtr = @ptrCast(@TypeOf(uartBufferPtr), &uartBufferPtr[1]);
    }
    else {
        uartBusy = false;
        // nrfGpio.OUT = nrfGpio.OUT ^ (1<<4);
    }
}

pub fn sendString(str: []const u8) void {
    while (uartBusy) {}
    uartBusy = true;
    uartBufferPtr = @ptrCast(@TypeOf(uartBufferPtr), &str[0]);
    uartBufferEnd = @ptrCast(@TypeOf(uartBufferEnd), &str[str.len-1]);

    sendBufferByte();
}

