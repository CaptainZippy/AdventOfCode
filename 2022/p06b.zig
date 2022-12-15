const std = @import("std");

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input06.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);

    const array8 = std.ArrayList(u8);
    var window = array8.init(allocator);
    const hdrSize:i32 = 14;
    try window.appendNTimes(0, hdrSize);
    var n: i32 = 0;
    const bits32_t = std.bit_set.IntegerBitSet(32);
    for (bytes) |c| {
        if (c >= 'a' and c <= 'z') {
            std.debug.assert(c >= 'a' and c <= 'z');
            n += 1;
            _ = window.orderedRemove(0);
            try window.append(c - 'a' + 1);
            var bits = bits32_t.initEmpty();
            for(window.items) |b| {
                bits.set(b);
            }
            if( bits.count() == hdrSize and n >= hdrSize) {
                break;
            }
        }
    }
    try stdout.print("{}", .{ n });
}
