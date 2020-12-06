
const std = @import("std");

pub fn main() !void {
    var stdout = std.io.getStdOut().writer();
    var memory: [2 * 1024 * 1024]u8 = undefined;
    var fixedBuffer = std.heap.FixedBufferAllocator.init(&memory);
    var alloc = &fixedBuffer.allocator;

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input03.txt", .{.read=true});
    const size = (try input.stat()).size;
    const bytes = try alloc.alloc(u8, size);
    const res = input.read(bytes);
    var it = std.mem.split(bytes, "\n");

    var hits:usize = 0;
    var pos:usize = 0;

    while(it.next()) |line|{
        if(line.len==0) continue;
        if( line[pos]=='#') {
            hits += 1;
        }
        pos = (pos + 3) % line.len;
    }
    try stdout.print("line {}\n", .{hits});
}
