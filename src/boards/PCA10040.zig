

const lib = @import("nrf_lib");
const Led = lib.led.Led;
const Pin = lib.gpio.Pin;

pub const led1 = Led{.pin = .{.pin=17}};
pub const led2 = Led{.pin = .{.pin=18}};
pub const led3 = Led{.pin = .{.pin=19}};
pub const led4 = Led{.pin = .{.pin=20}};

pub const leds = [_]Led{led1, led2, led3, led4};

pub fn init() void {
    for (leds) |led| { led.init(); }
}  
