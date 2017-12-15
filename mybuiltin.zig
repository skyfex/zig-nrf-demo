// These functions are provided when not linking against libc because LLVM
// sometimes generates code that calls them.

const builtin = @import("builtin");

// Avoid dragging in the debug safety mechanisms into this .o file,
// unless we're trying to test this file.
pub coldcc fn panic(msg: []const u8) -> noreturn {
    if (builtin.is_test) {
        @import("std").debug.panic("{}", msg);
    } else {
        unreachable;
    }
}

// Note that memset does not return `dest`, like the libc API.
// The semantics of memset is dictated by the corresponding
// LLVM intrinsics, not by the libc API.
export fn memset(dest: ?&u8, c: u8, n: usize) {
    @setDebugSafety(this, false);

    var index: usize = 0;
    while (index != n) : (index += 1)
        (??dest)[index] = c;
}

// Note that memcpy does not return `dest`, like the libc API.
// The semantics of memcpy is dictated by the corresponding
// LLVM intrinsics, not by the libc API.
export fn memcpy(noalias dest: ?&u8, noalias src: ?&const u8, n: usize) {
    @setDebugSafety(this, false);

    var index: usize = 0;
    while (index != n) : (index += 1)
        (??dest)[index] = (??src)[index];
}

export fn __stack_chk_fail() -> noreturn {
    if (builtin.mode == builtin.Mode.ReleaseFast or builtin.os == builtin.Os.windows) {
        @setGlobalLinkage(__stack_chk_fail, builtin.GlobalLinkage.Internal);
        unreachable;
    }
    @panic("stack smashing detected");
}
