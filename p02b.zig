
const std = @import("std");

pub fn main() !void {
    var stdout = std.io.getStdOut().writer();
    var memory: [2 * 1024 * 1024]u8 = undefined;
    var fixedBuffer = std.heap.FixedBufferAllocator.init(&memory);
    var alloc = &fixedBuffer.allocator;

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input02.txt", .{.read=true});
    const size = (try input.stat()).size;
    const bytes = try alloc.alloc(u8, size);
    const res = input.read(bytes);
    var it = std.mem.split(bytes, "\n");
    var valid:i32 = 0;
    while(it.next()) |line|{
        if(line.len==0) continue;
        var x = std.mem.tokenize(line, "-: ");
        const lo_ = x.next() orelse return error.Broken;
        const hi_ = x.next() orelse return error.Broken;
        const chr = x.next() orelse return error.Broken;
        const pass = x.next() orelse return error.Broken;
        const lo = try std.fmt.parseInt(u32, lo_, 10);
        const hi = try std.fmt.parseInt(u32, hi_, 10);
        const a:u32 = if(pass[lo-1]==chr[0]) 1 else 0;
        const b:u32 = if(pass[hi-1]==chr[0]) 1 else 0;
        try stdout.print("line {} {}\n", .{a,b});
        if( a+b==1) {
            valid += 1;
        }
    }
    try stdout.print("line {}\n", .{valid});
}
