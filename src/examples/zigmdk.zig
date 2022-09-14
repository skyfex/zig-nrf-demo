
const std = @import("std");
const nrf = @import("mdk");
usingnamespace @import("startup");

pub fn main() void {
    nrf.NRF_P0.*.PIN_CNF[13] = 3;
    nrf.NRF_P0.*.PIN_CNF[14] = 3;
    // nrf.P0.PIN_CNF[13] = .{.DIR = .Output};
    // nrf.P0.PIN_CNF[14] = .{.DIR = .Output};
    nrf.NRF_P0.*.OUTCLR = 1<<13;
    nrf.NRF_P0.*.OUTCLR = 1<<14;
}
