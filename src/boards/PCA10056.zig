
const lib = @import("nrf_lib");
const Led = lib.led.Led;
const Pin = lib.gpio.Pin;

pub const led1 = Led{.pin = .{.port=0, .pin=13}};
pub const led2 = Led{.pin = .{.port=0, .pin=14}};
pub const led3 = Led{.pin = .{.port=0, .pin=15}};
pub const led4 = Led{.pin = .{.port=0, .pin=16}};

pub const leds = [_]Led{led1, led2, led3, led4};


pub const uart1_rts = Pin{.port=0, .pin=5};
pub const uart1_txd = Pin{.port=0, .pin=6};
pub const uart1_cts = Pin{.port=0, .pin=7};
pub const uart1_rxd = Pin{.port=0, .pin=8};

pub fn init() void {
    for (leds) |led| { led.init(); }


}  
