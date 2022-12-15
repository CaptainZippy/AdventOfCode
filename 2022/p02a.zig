
const std = @import("std");

fn biggestFirst(context: void, a: u32, b: u32) std.math.Order { _=context; return std.math.order(b, a); }

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input02.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);
    var lines = std.mem.split(u8, bytes, "\n");

    var sum:u32 = 0;
    while(lines.next()) |line|{
        if(line.len!=0)
        {
            var a = line[0];
            var b = line[2];   
            //try stdout.print("OK {s} {} {} # {}\n", .{line, line.len, a, b});
            sum += switch (b) {
                'X' => 1,
                'Y' => 2,
                'Z' => 3,
                else => return error.IndexOutOfBounds,
            };

            var r:u8 = switch ( ((3+b-'X')-(a-'A'))%3 ) {
                0 => 3,
                1 => 6,
                2 => 0,
                else => return error.IndexOutOfBounds,
            };
            sum += r;
            try stdout.print("OK {s} {} {} # {} -> r={}\n", .{line, line.len, a, b, r});
        }
    }
    try stdout.print("OK {}", .{sum});
}
