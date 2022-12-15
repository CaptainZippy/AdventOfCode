const std = @import("std");

pub fn range(len: usize) []const u0 {
    return @as([*]u0, undefined)[0..len];
}

pub fn slurpFile(name:[]const u8, allocator:std.mem.Allocator) ![]const u8 {
    const cwd = std.fs.cwd();
    const input = try cwd.openFile(name, .{});
    const filesize = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, filesize);
    var nread = try input.read(bytes);
    std.debug.assert(nread == filesize);
    return bytes;
}

const Vec2 = struct {
    x:i32,
    y:i32,
};

pub fn solve(allocator:std.mem.Allocator) !void {
    const bytes = try slurpFile("input09.txt", allocator);
    var head:Vec2 = .{.x=0,.y=0};
    var tail:Vec2 = .{.x=0,.y=0};
    
    var lines = std.mem.split(u8, bytes, "\n");
    const hash = std.AutoHashMap(u64, u0);
    var visited = hash.init(allocator);
    try visited.put(0,0);
    while(lines.next()) |rawline| {
        const line = std.mem.trim(u8, rawline, " \r\n\t");
        if(line.len<3) continue;
        //std.debug.print("h({} {}) t=({} {}) '{s}'\n", .{head.x, head.y, tail.x, tail.y, line});

        const dir = line[0];
        const amt = try std.fmt.parseInt(u32, line[2..], 10);
        
        for( range(amt)) |_| {
            switch(dir) {
                'R' => {
                    if( tail.x < head.x ) {
                        tail.x = head.x;
                        tail.y = head.y;
                    }
                    head.x += 1;
                },
                'L' => {
                    if( tail.x > head.x ) {
                        tail.x = head.x;
                        tail.y = head.y;
                    }
                    head.x -= 1;
                },
                'U' => {
                    if( tail.y < head.y ) {
                        tail.x = head.x;
                        tail.y = head.y;
                    }
                    head.y += 1;
                },
                'D' => {
                    if( tail.y > head.y ) {
                        tail.x = head.x;
                        tail.y = head.y;
                    }
                    head.y -= 1;
                },
                else => return error.IndexOutOfBounds,
            }

            try visited.put( @bitCast(u32,tail.x) | @bitCast(u64,(@intCast(i64,tail.y)<<32)), 0);
            //std.debug.print("\th({} {}) t=({} {})\n", .{head.x, head.y, tail.x, tail.y});
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("COUNT {}\n", .{visited.count()});
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    try solve(allocator);
}
