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

fn bitsFromLine(line : []const u8) u64 {
    var bits: u64 = 0;
    const one: u64 = 1;
    for (line) |c| {
        var d = remap(c);
        std.debug.assert(d <= 52);
        bits |= (one << d);
    }
    return bits;
}

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input04.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);
    var lines = std.mem.split(u8, bytes, "\n");

    var sum: i32 = 0;
    while (lines.next()) |line| {
        if(line.len==0) break;
        var parts = std.mem.tokenize(u8, line, "-,");
        const a = try std.fmt.parseInt(i32, parts.next().?, 10);
        const b = try std.fmt.parseInt(i32, parts.next().?, 10);
        const c = try std.fmt.parseInt(i32, parts.next().?, 10);
        const d = try std.fmt.parseInt(i32, parts.next().?, 10);

        const mi = std.math.min(a,c);
        const mx = std.math.max(b,d);
        if(( a==mi and b==mx) or (c==mi and d==mx)) {
            sum += 1;
        }
    }
    try stdout.print("OK {}\n", .{sum});
}
