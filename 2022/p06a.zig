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
    
    var b:[4]u8 = .{0, 0, 0, 0};
    var n:i32 = 0;
    for (bytes) |c| {
        n += 1;
        b[0] = b[1];
        b[1] = b[2];
        b[2] = b[3];
        b[3] = c;
        if( n>=4 and b[0] != b[1] and b[0] != b[2] and b[0] != b[3] and b[1] != b[2] and b[1] != b[3] and b[2] != b[3]) {
            break;
        }        
    }
    try stdout.print("{any} {}", .{b, n});
}
