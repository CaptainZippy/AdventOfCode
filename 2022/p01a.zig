
const std = @import("std");

fn biggestFirst(context: void, a: u32, b: u32) std.math.Order { _=context; return std.math.order(b, a); }

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input01.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);
    var it = std.mem.split(u8, bytes, "\n");

    const PQ = std.PriorityQueue(u32, void, biggestFirst);
    var q = PQ.init(allocator, {});

    var sum:u32 = 0;
    while(it.next()) |line|{
        if(line.len==0) {
            try q.add(sum);
            sum = 0;
            continue;
        }
        sum += try std.fmt.parseInt(u32, line, 10);
    }
    try stdout.print("top3 {}\n", .{q.remove()+q.remove()+q.remove()});
}
