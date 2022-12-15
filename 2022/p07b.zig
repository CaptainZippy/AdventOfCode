const std = @import("std");

const File = struct {
    size: u32,
    name: []u8,
};
const Dir = struct {
    name: []u8,
    dirs: std.ArrayList(Dir),
    files: std.ArrayList(File),
};

fn mkdir(allocator: std.mem.Allocator, name: []const u8) !Dir {
    return Dir{
        .name = try allocator.dupe(u8, name),
        .dirs = std.ArrayList(Dir).init(allocator),
        .files = std.ArrayList(File).init(allocator),
    };
}

var xxxs:[]u8 = "";
var xxxn:usize = 10000000;

fn printit(writer: std.fs.File.Writer, dir: Dir, level: i32) !usize {
    var size:usize = 0;
//     var l = level;
//     while (l > 0) {
//   //      try writer.print("| ", .{});
//         l -= 1;
//     }
    //try writer.print("{s}\n", .{dir.name});
    for (dir.dirs.items) |d| {
        size += try printit(writer, d, level + 1);
    }
    for (dir.files.items) |f| {
        size += f.size;
        //l = level + 1;
        // while (l > 0) {
        //     try writer.print("| ", .{});
        //     l -= 1;
        // }
//        try writer.print("{s}={}\n", .{ f.name, f.size });
    }
    const freespace = 29427043;
    const minspace = 30000000;
    const required = minspace - freespace;

    if( size >= required) {
        if( size < xxxn ) {
            xxxn = size;
            xxxs = dir.name;
        }
        //try writer.print("{s:10}={:10}\n", .{ dir.name, size });
    }
    return size;
}

pub fn main() !void {
    var buffer: [1000000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const stdout = std.io.getStdOut().writer();

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input07.txt", .{});
    const bytes = try allocator.alloc(u8, (try input.stat()).size);
    _ = try input.read(bytes);

    var lines = std.mem.split(u8, bytes, "\n");

    var stack = std.ArrayList(*Dir).init(allocator);
    var root = try mkdir(allocator, "/");
    try stack.append(&root);
    var cur = &root;

    while (lines.next()) |line| {
        if (std.mem.lastIndexOfScalar(u8, line, ' ')) |space| {
            var name = line[space + 1 ..];
            if (std.mem.startsWith(u8, line, "$ ls")) {
                //std.debug.print("LS\n", .{});
            } else if (std.mem.startsWith(u8, line, "$ cd")) {
                //std.debug.print("CUR {}\n", .{stack.items.len});
                //std.debug.print("CD {s}\n", .{name});
                if (std.mem.eql(u8, name, "/")) {
                    try stack.resize(1);
                    cur = stack.items[0];
                } else if (std.mem.eql(u8, name, "..")) {
                    _ = stack.pop();
                    cur = stack.items[stack.items.len - 1];
                } else {
                    var old = cur;
                    for (cur.dirs.items) |d,i| {
                        if (std.mem.eql(u8, d.name, name)) {
                            try stack.append(&cur.dirs.items[i]);
                            cur = stack.items[stack.items.len - 1];
                            break;
                        }
                    }
                    std.debug.assert(old != cur);
                }
            } else if (std.mem.startsWith(u8, line, "dir")) {
                //std.debug.print("DIR {s}\n", .{name});
                try cur.dirs.append(try mkdir(allocator, line[space + 1 ..]));
            } else {
                var size = try std.fmt.parseInt(u32, line[0..space], 10);
                const f = File{
                    .size = size,
                    .name = try allocator.dupe(u8, name),
                };
                try cur.files.append(f);
            }
        }
    }
    _ = try printit(stdout, root, 0);
    try stdout.print("{s} {}\n", .{xxxs, xxxn});
}
