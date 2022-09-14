
const std = @import("std");
const nrf = @import("nrf");
const lib = @import("./lib.zig");
const gpio = lib.gpio;

pub const Led = struct {

    pin: gpio.Pin,

    pub fn init(self: Led) void {
        self.pin.set_PIN_CNF(.{.DIR = .Output});
        self.off();
    }

    pub fn on(self: Led) void {
        self.pin.clear();
    }

    pub fn off(self: Led) void {
        self.pin.set();
    }
};

