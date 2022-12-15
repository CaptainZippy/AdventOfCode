const std = @import("std");

fn biggestFirst(context: void, a: u32, b: u32) std.math.Order {
    _ = context;
    return std.math.order(b, a);
}

fn remap(c: u8) u6 {
    return switch (c) {
        'a'...'z' => @intCast(u6, c - 'a'),
        'A'...'Z' => @intCast(u6, c - 'A' + 26),
        else => 0,
    };
}

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input03.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);
    var lines = std.mem.split(u8, bytes, "\n");

    var sum: i32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var lbits: u64 = 0;
        var rbits: u64 = 0;
        var lhs = line[0 .. line.len / 2];

        const one: u64 = 1;
        for (lhs) |c| {
            var d = remap(c);
            std.debug.assert(d <= 52);
            lbits |= (one << d);
        }
        var rhs = line[line.len / 2 ..];
        for (rhs) |c| {
            var d = remap(c);
            std.debug.assert(d <= 52);
            rbits |= (one << d);
        }
        var c = lbits & rbits;
        var x = std.math.log2_int(u64,c) + 1;
        //try stdout.print("OK {x} {} {}\n", .{ x, lbits, rbits });
        sum += x;
    }
    try stdout.print("OK {}\n", .{sum});
}
