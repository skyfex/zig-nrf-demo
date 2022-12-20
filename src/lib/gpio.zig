
const nrf = @import("nrf");
const gpio = @This();

pub const Pin = packed struct {
    port: u3 = 0,
    pin: u5 = 0,


    pub fn make(port: u3, pin: u5) Pin {
        return .{.port = port, .pin = pin};
    }

    fn getPort(self: Pin) *volatile nrf.GPIO_Type {
        return gpio.getPort(self.port);
    }

    pub fn PIN_CNF(self: Pin) *volatile nrf.GPIO_PinCnf {
        return self.getPort().PIN_CNF[self.pin];
    }

    pub fn set_PIN_CNF(self: Pin, pin_cnf: nrf.GPIO_PinCnf) void {
        self.getPort().PIN_CNF[self.pin] = pin_cnf;
    }

    pub fn set(self: Pin) void {
        self.getPort().OUTSET = @as(u32,1)<<self.pin;
    }

    pub fn clear(self: Pin) void {
        self.getPort().OUTCLR = @as(u32,1)<<self.pin;
    }

    pub fn out(self: Pin, val: u1) void {
        self.getPort().OUTCLR = @as(u32,val)<<self.pin;
    }

    pub fn pselValue(self: Pin) nrf.common.PselReg {
        return .{
            .PIN = self.pin,
            // TODO: Cleaner way to get type of PORT field?
            .PORT = @intCast(@TypeOf(self.pselValue().PORT), self.port),
            .CONNECT = .Connected
        };
    }
};

pub fn getPort(port_num: usize) *volatile nrf.GPIO_Type {
    return nrf.GPIOs[port_num];
}
