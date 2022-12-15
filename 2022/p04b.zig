const std = @import("std");

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

        if(c <= b and d >= a) {
            sum += 1;
        }
    }
    try stdout.print("OK {}\n", .{sum});
}
