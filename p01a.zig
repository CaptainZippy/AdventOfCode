
const std = @import("std");

const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var memory: [2 * 1024 * 1024]u8 = undefined;
    var fixedBuffer = std.heap.FixedBufferAllocator.init(&memory);
    var alloc = &fixedBuffer.allocator;

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input01.txt", .{.read=true});
    const size = (try input.stat()).size;
    try stdout.print("size {}\n", .{size});
    const bytes = try alloc.alloc(u8, size);
    const res = input.read(bytes);
    try stdout.print("size {}\n", .{res});
    var it = std.mem.split(bytes, "\n");
    var arr = std.ArrayList(u32).init(alloc);
    while(it.next()) |line|{
    //for (std.mem.split(bytes, "\n")) |line| {
        if(line.len==0) continue;
        const v = try std.fmt.parseInt(u32, line, 10);
        try arr.append(v);
    }
    for(arr.items) |a,i| {
        for(arr.items[i+1..]) |b,j| {
            for(arr.items[b+1..]) |c,k| {
            if(a+b == 2020) {
                try stdout.print("line {} {} {} {} {}\n", .{i, j, a, b, a*b});
            }
        }
    }
}
