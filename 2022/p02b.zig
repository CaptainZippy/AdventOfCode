
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
            var c = switch (b) {
                'X' => 0+1+((a-'A'+2)%3), // lose
                'Y' => 3+1+((a-'A'  )  ), // draw
                'Z' => 6+1+((a-'A'+1)%3), // win
                else => return error.IndexOutOfBounds,
            };
            sum += c;

            try stdout.print("OK {} {} {} \n", .{a,b,c});
        }
    }
    try stdout.print("OK {}", .{sum});
}
