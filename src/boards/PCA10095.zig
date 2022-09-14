

const lib = @import("nrf_lib");
const Led = lib.led.Led;
const Pin = lib.gpio.Pin;

pub const led1 = Led{.pin = .{.port=0, .pin=28}};
pub const led2 = Led{.pin = .{.port=0, .pin=29}};
pub const led3 = Led{.pin = .{.port=0, .pin=30}};
pub const led4 = Led{.pin = .{.port=0, .pin=31}};

pub const leds = [_]Led{led1, led2, led3, led4};

pub fn init() void {
    for (leds) |led| { led.init(); }
}  
