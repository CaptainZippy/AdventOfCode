const std = @import("std");

pub fn range(len: usize) []const u0 {
    return @as([*]u0, undefined)[0..len];
}

pub fn main() !void {
    var buffer: [1000000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input08.txt", .{});
    const bytes = try allocator.alloc(u8, (try input.stat()).size);
    _ = try input.read(bytes);

    const gridSize = 99;
    //const gridSize = 5;
    var lines = std.mem.split(u8, bytes, "\n");
    var grid: [gridSize][gridSize]u8 = undefined;
    var visible: [gridSize][gridSize]u1 = .{};
    {
        var i: usize = 0;
        while (lines.next()) |line| {
            if (line.len != 0) {
                std.mem.copy(u8, &grid[i], line[0..gridSize]);
                i += 1;
            }
        }
    }

    // from left
    for (range(gridSize)) |_, outer| {
        var r = outer;
        var hi: i32 = -1;
        for (range(gridSize)) |_, inner| {
            var c = inner;
            if (grid[r][c] > hi) {
                visible[r][c] = 1;
                hi = grid[r][c];
            }
        }
    }
    // right side
    for (range(gridSize)) |_, outer| {
        var r = outer;
        var hi: i32 = -1;
        for (range(gridSize)) |_, inner| {
            var c = gridSize-1-inner;
            if (grid[r][c] > hi) {
                visible[r][c] = 1;
                hi = grid[r][c];
            }
        }
    }
    // top side
    for (range(gridSize)) |_, outer| {
        var c = outer;
        var hi: i32 = -1;
        for (range(gridSize)) |_, inner| {
            var r = inner;
            if (grid[r][c] > hi) {
                visible[r][c] = 1;
                hi = grid[r][c];
            }
        }
    }
    // bottom side
    for (range(gridSize)) |_, outer| {
        var c = outer;
        var hi: i32 = -1;
        for (range(gridSize)) |_, inner| {
            var r = gridSize-1-inner;
            if (grid[r][c] > hi) {
                visible[r][c] = 1;
                hi = grid[r][c];
            }
        }
    }

    // calc

    var num: i32 = 0;
    for (range(gridSize)) |_, r| {
        std.debug.print("{any}\n", .{visible[r]});
        for (range(gridSize)) |_, c| {
            //std.debug.print(">{} {}\n", .{num, visible[r][c]});
            if(visible[r][c]!=0) {
                num += 1;

            //num = num + visible[r][c];
            }
            //std.debug.print("<{}\n", .{num});
        }
    }

    const stdout = std.io.getStdOut().writer();
    try stdout.print("OK '{}'\n", .{num});
}
