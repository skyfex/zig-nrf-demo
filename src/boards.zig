
pub const DeviceId = @import("../zdk/devices/nrfdevice.zig").DeviceId;

pub const BoardInfo = struct {
    id:     BoardId,
    device: ?DeviceId = null,

    pub fn name(self: BoardInfo) []const u8 { return @tagName(self.id); }
};

pub const BoardId = enum {
    blank,
    PCA10040,
    PCA10056,
    PCA10095,
    microbit,
    microbit_v2,
};

pub const blank = BoardInfo{
    .id     = .blank,
    .device = null
};

pub const PCA10040 = BoardInfo{
    .id     = .PCA10040,
    .device = .NRF52832_xxaa
};

pub const PCA10056 = BoardInfo{
    .id     = .PCA10056,
    .device = .NRF52840_xxaa
};

pub const PCA10095 = BoardInfo{
    .id     = .PCA10095,
    .device = .NRF5340_xxaa
};

pub const microbit = BoardInfo{
    .id     = .microbit,
    .device = .NRF51822_xxaa
};

pub const microbit_v2 = BoardInfo{
    .id     = .microbit_v2,
    .device = .NRF52833_xxaa
};

const num_boards = @typeInfo(BoardId).Enum.fields.len;
const board_table: [num_boards]BoardInfo = blk: {
    var tmp: [num_boards]BoardInfo = undefined;
    for (@typeInfo(BoardId).Enum.fields) |t, i| {
        tmp[i] = @field(@This(), t.name);
    }
    break :blk tmp;
};

pub fn getBoardInfo(id: BoardId) BoardInfo {
    return board_table[@enumToInt(id)];
}
