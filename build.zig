const std = @import("std");
const Builder = std.build.Builder;
const Step = std.build.Step;

const zdk_build = @import("./zdk/build.zig");
const devices = zdk_build.devices;
const boards = @import("./src/boards.zig");

const zdkPath = "./zdk";

//  DebugStep
// ===========================================
// Print debug messages before building NRF programs    

pub const DebugStep = struct {
    step: Step,
    builder: *Builder,
    exe_step: *std.build.LibExeObjStep,
    board: boards.BoardInfo,

    pub fn create(builder: *Builder, name: []const u8, exe_step: *std.build.LibExeObjStep, board: boards.BoardInfo) *DebugStep {
        const self = builder.allocator.create(DebugStep) catch unreachable;
        self.* = DebugStep{
            .step = Step.init(.custom, name, builder.allocator, make),
            .builder = builder,
            .exe_step = exe_step,
            .board = board
        };
        return self;
    }

    pub fn make(step: *Step) !void {
        const self = @fieldParentPtr(DebugStep, "step", step);

        // TODO: Ability to toggle between debug and info?
        // _ = try std.io.getStdOut().writer().write("\n");
        std.log.info("nRF-Demo", .{});
        std.log.info("  Board: {s}", .{@tagName(self.board.id)}); 
        // _ = try std.io.getStdOut().writer().write("\n");
    }
};

pub const NrfProgram = struct {
    domain: devices.DomainId = .NotApplicable,
    board: boards.BoardId,
};

pub fn nrfProgram(b: *std.build.Builder, 
                  nrf_p: NrfProgram, 
                  zdk_p: zdk_build.ZdkProgram) zdk_build.ZdkSteps {


    const board_info = boards.getBoardInfo(nrf_p.board);

    // Expand root source path
    var zdk_p2 = zdk_p;
    zdk_p2.device_id = board_info.device;
    if (zdk_p2.root_src == null) {
        zdk_p2.root_src = b.fmt("src/examples/{s}.zig", .{zdk_p.name});
    }

    // Set up ZDK build configuration
    var zdk_steps = zdk_build.zdkProgram(b, zdk_p2, zdkPath) catch unreachable;
    var exe = zdk_steps.exe;

    const opt = b.addOptions();
    opt.addOption(boards.BoardId,   "board",  nrf_p.board);
    opt.addOption(devices.DomainId, "domain", nrf_p.domain);
    exe.addOptions("nrf_config", opt);

    const dbg = b.step(b.fmt("{s}-dbg", .{zdk_p.name}), "Print debug info from nRF-demo");
    const dbg_step = DebugStep.create(b, "dbg", exe, board_info);
    dbg.dependOn(&dbg_step.step);
    exe.step.dependOn(&dbg_step.step);

    // const nrf_pkg_o = for (exe.packages.items) |pkg| {
    //     if (std.mem.eql(u8, pkg.name, "nrf")) {
    //         break pkg;
    //     }
    // } else null;
    if (exe.getPackage("nrf")) |nrf_pkg| {
        // std.log.info("Got nrf package", .{});
        const nrf_lib_pkg = std.build.Pkg{
                .name = "nrf_lib",
                .source = .{ .path = "./src/lib/lib.zig" },
                .dependencies = &[_]std.build.Pkg{ nrf_pkg }
            };
        exe.addPackage(nrf_lib_pkg);
        const board_path = b.fmt("./src/boards/{s}.zig", .{board_info.name()});
        exe.addPackage(.{
            .name = "board",
            .source = .{ .path = board_path },
            .dependencies = &[_]std.build.Pkg{ nrf_pkg, nrf_lib_pkg }
            }
        );
    }

    return zdk_steps;
}

pub fn build(b: *std.build.Builder) !void {

    try zdk_build.build(b);

    const board = b.option(
        boards.BoardId,
        "board",
        "Set to desired development kit board",
    ) orelse boards.BoardId.PCA10040;
   
    const domain = b.option(
        devices.DomainId,
        "domain",
        "Set to desired domain to target",
    ) orelse devices.DomainId.NotApplicable;

    const nrf_p = NrfProgram{.board=board, .domain = domain};

    _ = nrfProgram(b, nrf_p, .{.name="blank"      });
    _ = nrfProgram(b, nrf_p, .{.name="led",      .heap_size=1024, .stack_size=1024});
    _ = nrfProgram(b, nrf_p, .{.name="zigmdk"     });
    _ = nrfProgram(b, nrf_p, .{.name="cmdk"       });
    _ = nrfProgram(b, nrf_p, .{.name="async"      });
    _ = nrfProgram(b, nrf_p, .{.name="asyncTimer" });
    _ = nrfProgram(b, nrf_p, .{.name="timer"      });
    _ = nrfProgram(b, nrf_p, .{.name="microbit"   });

    const multi      = b.step("multi", "Demo compiling for multiple devices");
    const multi_prog = b.step("multi-prog", "Demo compiling and programming multiple devices");
    const multi_reset = b.step("multi-reset", "Reset multiple devices");

    const led_1 = nrfProgram(b, .{.board=.PCA10040}, .{.name="led_1", .root_src="./src/examples/led.zig", .serial_number="682566997"}); 
    multi.dependOn(led_1.all);
    multi_prog.dependOn(led_1.prog);
    multi_reset.dependOn(led_1.reset);

    const led_2 = nrfProgram(b, .{.board=.PCA10056}, .{.name="led_2", .root_src="./src/examples/led.zig", .serial_number="683655956"}); 
    multi.dependOn(led_2.all);
    multi_reset.dependOn(led_2.reset);

    // dbg.dependOn(&dbg_step.step);
    // exe.step.dependOn(&dbg_step.step);
    // nrfProgram(b, nrf_p, .{.name="microbit"   });


}

