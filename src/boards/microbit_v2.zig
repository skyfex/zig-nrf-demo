
const nrf = @import("nrf");
const P0 = nrf.P0;

const lib = @import("nrf_lib");
const Led = lib.led.Led;
const Pin = lib.gpio.Pin;


// -- Board configuration --

// GPIO on nRF52833    Allocation           KL27 Landing       Edge Connector name
// P0.00               SPKR1                KL27_DAC     
// P1.05               COL4                 N                  P6
// P0.02               RING0                N                  P0
// P0.03               RING1                N                  P1
// P0.04               RING2                N                  P2
// P0.05               MIC_IN               N    
// P0.06               UART_INTERNAL_RX     P17 (LPUART1_RX)     
// P1.08               UART_INTERNAL_TX     P25 (LPUART1_TX)     
// P0.08               I2C_INT_SCL          P22 (I2C1_SCL)   
// P0.10               GPIO1                N                  P8
// P0.09               GPIO2                N                  P9
// P0.11               COL2                 N                  P7
// P1.02               GPIO3                N                  P16
// P0.19               ROW5                 N                   
// P0.14               BTN_A                N                  P5
// P0.23               BTN_B                N                  P11
// P1.04               FACE_TOUCH           N    
// P0.16               I2C_INT_SDA          P23                (I2C1_SDA)   
// P0.17               SCK_EXTERNAL         N                  P13
// P0.01               MISO_EXTERNAL        N                  P14
// P0.13               MOSI_EXTERNAL        N                  P15
// P0.20               RUN_MIC              N    
// P0.21               ROW1                 N    
// P0.22               ROW2                 N    
// P0.15               ROW3                 N    
// P0.24               ROW4                 N    
// P0.25               COMBINED_SENSOR_INT  P11                SENSOR_nINT      
// P0.26               I2C_EXT_SCL          N                  P19
// P1.00               I2C_EXT_SDA          N                  P20
// P0.12               GPIO4                N                  P12
// P0.28               COL1                 N                  P4
// P0.31               COL3                 N                  P3
// P0.30               COL5                 N                  P10

// Physical mapping of LEDs
const ledCol1 = Pin.make(0, 28);
const ledCol2 = Pin.make(0, 11);
const ledCol3 = Pin.make(0, 31);
const ledCol4 = Pin.make(1, 5);
const ledCol5 = Pin.make(0, 30);

const ledRow1 = Pin.make(0, 21);
const ledRow2 = Pin.make(0, 22);
const ledRow3 = Pin.make(0, 15);
const ledRow4 = Pin.make(0, 24);
const ledRow5 = Pin.make(0, 19);

const ledCols = [_]Pin{ledCol1, ledCol2, ledCol3, ledCol4, ledCol5};
const ledRows = [_]Pin{ledRow1, ledRow2, ledRow3, ledRow4, ledRow5};


// Logical mapping
// See: https://lancaster-university.github.io/microbit-docs/ubit/display/
// 1.1  2.4  1.2  2.5  1.3
// 3.4  3.5  3.6  3.7  3.8
// 2.2  1.9  2.3  3.9  2.1
// 1.8  1.7  1.6  1.5  1.4
// 3.3  2.7  3.1  2.6  3.2

// Use 5 LEDs on second logical row as standardized board LEDs
pub const led1 = Led{.pin = ledCol1};
pub const led2 = Led{.pin = ledCol2};
pub const led3 = Led{.pin = ledCol3};
pub const led4 = Led{.pin = ledCol4};
pub const led5 = Led{.pin = ledCol5};

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
    // P0.OUTSET = @as(u32,1)<<ledRow3;
    ledRow3.set();
}  
