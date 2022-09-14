
usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");

pub fn main() void {

  board.init();

  nrf.TIMER0.PRESCALER.set(4); // Should give 1us resolution with 16Mhz clock
  nrf.TIMER0.MODE.set(.Timer);
  nrf.TIMER0.BITMODE.set(._32Bit);
  nrf.TIMER0.CC[0] = 500_000;
  nrf.TIMER0.CC[1] = 300_000;
  nrf.TIMER0.CC[2] = 1_000_000;

  nrf.TIMER0.EVENTS_COMPARE[0].clear();
  nrf.TIMER0.EVENTS_COMPARE[1].clear();
  nrf.TIMER0.EVENTS_COMPARE[2].clear();
  nrf.TIMER0.TASKS_START.trigger();   

  var i: i32 = 2;
  while (i != 0) {
    if (nrf.TIMER0.EVENTS_COMPARE[0].getClear()) {
      board.led1.on();
      i -= 1;      
    }
    if (nrf.TIMER0.EVENTS_COMPARE[1].getClear()) {
      board.led2.on();
      i -= 1;
    }
  }
  nrf.TIMER0.EVENTS_COMPARE[2].waitClear();
  board.led3.on();  

}
