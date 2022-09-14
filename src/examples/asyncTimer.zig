
usingnamespace @import("startup");

const std = @import("std");
const nrf = @import("nrf");
const lib = @import("nrf_lib");
const board = @import("board");

const Led = lib.led.Led;

const SimpleEventLoop = struct {
  x: i32 = 0,
  active: bool = false,
  frame_i: usize = 0,
  frames: [8]anyframe = undefined,

  pub fn init(self: *SimpleEventLoop) void {
    self.x = 1;
    self.frame_i = 0;
    self.active = true;
  }

  pub fn finish(self: *SimpleEventLoop) void {
    self.active = false;
  }

  pub fn yield(self: *SimpleEventLoop) void {
    self.x += 1;
    suspend {
        self.frames[self.frame_i] = @frame();
        self.frame_i += 1;
    }
  }

  pub fn run(self: *SimpleEventLoop) void {
    _ = self;
    while (self.active) {
        var num_frames = self.frame_i;
        var frames: [8]anyframe = self.frames;
        self.frame_i = 0;
        var i: usize = 0;
        while (i < num_frames) : (i += 1) {
            resume frames[i];
        }
    }
  }

};

pub var event_loop = SimpleEventLoop{};

const Timer = struct {
    timer: *volatile nrf.TIMER_Type,
    cc: usize,

    pub fn wait(self: Timer, cycles: u32) void {
        const cc = self.cc;
        self.timer.TASKS_CAPTURE[cc].trigger();
        const prevCC = self.timer.CC[cc];
        self.timer.EVENTS_COMPARE[cc].clear();
        self.timer.CC[cc] = prevCC+cycles;
        self.timer.EVENTS_COMPARE[cc].waitClear();
    }

};

pub fn foo(t: Timer, led: Led) void {
    t.wait(300_000);
    led.on();
    t.wait(300_000);
    led.off();
}

pub fn bar(t: Timer, led: Led) void {
    t.wait(500_000);
    led.on();
    t.wait(700_000);
    led.off();
}

pub fn foobar(t1: Timer, t2: Timer) void {
    foo(t1, board.led3);
    bar(t2, board.led4);
}

pub fn mainAsync() void {

    nrf.TIMER0.PRESCALER.set(4); // Should give 1us resolution with 16Mhz clock
    nrf.TIMER0.MODE.set(.Timer);
    nrf.TIMER0.BITMODE.set(._32Bit);
    nrf.TIMER0.TASKS_START.trigger();
 
    const t0 = Timer{.timer = nrf.TIMER0, .cc = 0};
    const t1 = Timer{.timer = nrf.TIMER0, .cc = 1};
    const t2 = Timer{.timer = nrf.TIMER0, .cc = 2};
    const t3 = Timer{.timer = nrf.TIMER0, .cc = 3};

    foo(t0, board.led1);
    bar(t1, board.led2);
    foobar(t2, t3);

    var af = async foo(t0, board.led1);
    var bf = async bar(t1, board.led2);
    foobar(t2, t3);
    await af;
    await bf;

    t0.wait(100_000);
    for (board.leds) |led| led.on();
    t0.wait(500_000);
    for (board.leds) |led| led.off();
}


pub fn callMainAsync() void {
    defer event_loop.finish();
    mainAsync();
}

pub fn main() void {

    board.init();

    event_loop.init();
    var frame: @Frame(callMainAsync) = undefined;
    _ = @asyncCall(&frame, {}, callMainAsync, .{});
    event_loop.run();
}
