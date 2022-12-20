
const nrf = @import("nrf");
const P0 = nrf.GPIO;

const lib = @import("nrf_lib");
const Led = lib.led.Led;
const Pin = lib.gpio.Pin;

// -- Board configuration --

// Physical mapping of LEDs
const ledCol1 = Pin.make(0, 4);
const ledCol2 = Pin.make(0, 5);
const ledCol3 = Pin.make(0, 6);
const ledCol4 = Pin.make(0, 7);
const ledCol5 = Pin.make(0, 8);
const ledCol6 = Pin.make(0, 9);

const ledCol7 = Pin.make(0, 10);
const ledCol8 = Pin.make(0, 11);
const ledCol9 = Pin.make(0, 12);
const ledRow1 = Pin.make(0, 13);
const ledRow2 = Pin.make(0, 14);
const ledRow3 = Pin.make(0, 15);

const ledCols = [_]Pin{ledCol1, ledCol2, ledCol3, ledCol4, ledCol5, ledCol6, ledCol7, ledCol8, ledCol9};
const ledRows = [_]Pin{ledRow1, ledRow2, ledRow3};


// Logical mapping
// See: https://lancaster-university.github.io/microbit-docs/ubit/display/
// 1.1  2.4  1.2  2.5  1.3
// 3.4  3.5  3.6  3.7  3.8
// 2.2  1.9  2.3  3.9  2.1
// 1.8  1.7  1.6  1.5  1.4
// 3.3  2.7  3.1  2.6  3.2

// Use 5 LEDs on second logical row as standardized board LEDs
pub const led1 = Led{.pin = ledCol4};
pub const led2 = Led{.pin = ledCol5};
pub const led3 = Led{.pin = ledCol6};
pub const led4 = Led{.pin = ledCol7};
pub const led5 = Led{.pin = ledCol8};

pub const leds = [_]Led{led1, led2, led3, led4, led5};


pub fn init() void {
    // Set all LED pins to output
    for (ledCols++ledRows) |l| {
        l.set_PIN_CNF(.{.DIR = .Output});
    }
    // Pull columns high to turn them off
    for (ledCols) |c| {
        c.set();
    }
    // Pull rows low to turn them off
    for (ledRows) |r| {
        r.clear();
    }
    // Turn on row 3 by default for standard board LEDs
    ledRow3.set();
}  
