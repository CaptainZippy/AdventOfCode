const std = @import("std");

pub fn range(len: usize) []const u0 {
    return @as([*]u0, undefined)[0..len];
}

pub fn main() !void {
    var buffer: [1000000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const cwd = std.fs.cwd();
    const gridSize = 99;
    //const gridSize = 5;
    const input = try cwd.openFile("input08.txt", .{});
    const bytes = try allocator.alloc(u8, (try input.stat()).size);
    _ = try input.read(bytes);

    
    var lines = std.mem.split(u8, bytes, "\n");
    var grid: [gridSize][gridSize]u8 = undefined;
    {
        var i: usize = 0;
        while (lines.next()) |line| {
            if (line.len != 0) {
                std.mem.copy(u8, &grid[i], line[0..gridSize]);
                i += 1;
            }
        }
    }

    var bestR:usize = 0;
    var bestC:usize = 0;
    var bestScore:usize = 0;
    for (range(gridSize)) |_, row| {
        for (range(gridSize)) |_, col| {
            //if(col == 0 or col==gridSize-1 or row==0 or row==gridSize-1) continue;
            var h = grid[row][col];
            //left
            var c = col;
            const left = while(true) {
                if(c==0) { break col; }
                c -= 1;
                if(grid[row][c] >= h) { break col-c; }
            };
            //right
            c = col;
            const right = while(true) {
                c += 1;
                if(c==gridSize) { break gridSize-col-1; }
                if(grid[row][c] >= h) { break c-col; }
            };

            // up
            var r = row;
            const up = while(true) {
                if(r==0) { break row; }
                r -= 1;
                if(grid[r][col] >= h) { break row-r; }
            };
            // down
            r = row;
            const down = while(true) {
                r += 1;
                if(r==gridSize) { break gridSize-row-1; }
                if(grid[r][col] >= h) { break r-row; }
            };
            
            var score = left*right*up*down;
            if( score > bestScore ) {
                bestScore = score;
                bestR = row;
                bestC = col;
            }
            //std.debug.print("{},{} = l={} r={} u={} d={}\n", .{row, col, left,right,up,down});
        }
    }


    const stdout = std.io.getStdOut().writer();
    try stdout.print("OK '{}' {} {}\n", .{bestScore, bestR, bestC});
}
