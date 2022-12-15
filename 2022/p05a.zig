const std = @import("std");

//     [B]             [B] [S]        
//     [M]             [P] [L] [B] [J]
//     [D]     [R]     [V] [D] [Q] [D]
//     [T] [R] [Z]     [H] [H] [G] [C]
//     [P] [W] [J] [B] [J] [F] [J] [S]
// [N] [S] [Z] [V] [M] [N] [Z] [F] [M]
// [W] [Z] [H] [D] [H] [G] [Q] [S] [W]
// [B] [L] [Q] [W] [S] [L] [J] [W] [Z]
//  1   2   3   4   5   6   7   8   9 

pub fn main() !void {
    var buffer: [100000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input05.txt", .{});
    const size = (try input.stat()).size;
    const bytes = try allocator.alloc(u8, size);
    _ = try input.read(bytes);
    var lines = std.mem.split(u8, bytes, "\n");

    const array = std.ArrayList(u8);
    var stacks:[10]array = .{
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
        array.init(allocator),
    };
    try stacks[1].appendSlice("BWN");
    try stacks[2].appendSlice("LZSPTDMB");
    try stacks[3].appendSlice("QHZWR");
    try stacks[4].appendSlice("WDVJZR");
    try stacks[5].appendSlice("SHMB");
    try stacks[6].appendSlice("LGNJHVPB");
    try stacks[7].appendSlice("JQZFHDLS");
    try stacks[8].appendSlice("WSFJGQB");
    try stacks[9].appendSlice("ZWMSCDJ");

    while (lines.next()) |line| {
        if(line.len==0) break;
        var parts = std.mem.tokenize(u8, line, " ");
        _ = parts.next(); // Move
        const num = try std.fmt.parseInt(usize, parts.next().?, 10); 
        _ = parts.next(); // from
        const src = try std.fmt.parseInt(usize, parts.next().?, 10);
        _ = parts.next(); // to
        const dst = try std.fmt.parseInt(usize, parts.next().?, 10);

        var c:usize = 0;
        while( c < num ) {
            var x = stacks[src].pop();
            try stacks[dst].append(x);
            c += 1;
        }
    }
    for( stacks[1..10] ) |s| {
        try stdout.print("{c}", .{s.items[s.items.len-1]});

    }
}
