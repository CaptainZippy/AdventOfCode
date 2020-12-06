
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

    var r1d1:usize = 0;
    var r3d1:usize = 0;
    var r5d1:usize = 0;
    var r7d1:usize = 0;
    var r1d2:usize = 0;
    var i:u32 = 0;

    while(it.next()) |line|{
        if(line.len==0) continue;
        const idx1 = i % line.len;
        const idx3 = (3*i) % line.len;
        const idx5 = (5*i) % line.len;
        const idx7 = (7*i) % line.len;
        const idxh = (i/2) % line.len;
        try stdout.print("xlinex {} {}  * \n", .{line.len, line});
        try stdout.print("line {} $ {} $ {} {} {} {}\n", .{line,i,idx1,idx3,idx5,idx7});

        if( line[idx1] == '#') {
            r1d1 += 1;
        }
        if( line[idx3] == '#') {
            r3d1 += 1;
        }
        if( line[idx5] == '#') {
            r5d1 += 1;
        }
        if( line[idx7] == '#') {
            r7d1 += 1;
        }
        if( (i % 2) == 0 and line[idxh]=='#') {
            r1d2 += 1;
        }
        i += 1;
    }
    try stdout.print("line {} {} {} {} {}\n", .{r1d1,r3d1,r5d1,r7d1,r1d2});
    try stdout.print("line {}\n", .{r1d1*r3d1*r5d1*r7d1*r1d2});
}
