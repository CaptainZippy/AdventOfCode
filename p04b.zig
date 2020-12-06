
const std = @import("std");

fn idFromKey(key : []const u8) i32 {
    var a:i32 = key[0];
    var b:i32 = key[1];
    var c:i32 = key[2];
    return (a<<16) | (b<<8) | c;
}

fn validYear(key: []const u8, lo:u32, hi:u32) bool {
    if( key.len!=4) return false;
    var yr = std.fmt.parseInt(u32, key, 10) catch return false;
    return yr >= lo and yr <= hi;
}

fn validHgt(key: []const u8) bool {
    if( key.len<4) return false;
    var n = std.fmt.parseInt(u32, key[0..key.len-2], 10) catch return false;
    if( std.mem.eql(u8, key[key.len-2..], "cm")) return n >= 150 and n <= 193;
    if( std.mem.eql(u8, key[key.len-2..], "in")) return n >= 59 and n <= 76;
    return false;
}
fn validHcl(key: []const u8) bool {
    if( key.len!=7) return false;
    if( key[0]!='#' ) return false;
    for(key[1..]) |b| {
        if( switch(b) {
            '0'...'9' => false,
            'a'...'f' => false,
            else => true,
        }) return false;
    }
    return true;
}
fn validEcl(key: []const u8) bool {
    if( key.len!=3) return false;
    return switch( idFromKey(key) ) {
        idFromKey("amb"),
        idFromKey("blu"),
        idFromKey("brn"),
        idFromKey("gry"),
        idFromKey("grn"),
        idFromKey("hzl"),
        idFromKey("oth") => true,
        else => false,
    };
}
fn validPid(key: []const u8) bool {
    if( key.len!=9) return false;
    var pid = std.fmt.parseInt(u32, key, 10) catch return false;
    return true;
}

pub fn main() !void {
    var stdout = std.io.getStdOut().writer();
    var memory: [2 * 1024 * 1024]u8 = undefined;
    var fixedBuffer = std.heap.FixedBufferAllocator.init(&memory);
    var alloc = &fixedBuffer.allocator;

    const cwd = std.fs.cwd();
    const input = try cwd.openFile("input04.txt", .{.read=true});
    const size = (try input.stat()).size;
    const bytes = try alloc.alloc(u8, size);
    const res = input.read(bytes);
    
    var lineit = std.mem.split(bytes, "\n\n");
    var valid:u32 = 0;
    while(lineit.next()) |line| {
        if(line.len==0) continue;

        var bits:u32 = 0;
        var grpit = std.mem.tokenize(line, " \n");
        while(grpit.next()) |grp| {
            var key = grp[0..3];
            var val = grp[4..];
            const zero:u32 = 0;

            bits |= switch( idFromKey(key) ) {
                idFromKey("byr") => if(validYear(val,1920,2002)) (1<<0) else zero,
                idFromKey("iyr") => if(validYear(val,2010,2020)) (1<<1) else zero,
                idFromKey("eyr") => if(validYear(val,2020,2030)) (1<<2) else zero,
                idFromKey("hgt") => if(validHgt(val)) (1<<3) else zero,
                idFromKey("hcl") => if(validHcl(val)) (1<<4) else zero,
                idFromKey("ecl") => if(validEcl(val)) (1<<5) else zero,
                idFromKey("pid") => if(validPid(val)) (1<<6) else zero,
                idFromKey("cid") => zero,//1<<7,
                else =>  zero,
            };
        }
        if( bits == 0b1111111) {
            valid += 1;
            //try stdout.print("line {} {}\n", .{line, bits});
        }
        //i += 1;
    }
    try stdout.print("line {}\n", .{valid});
}
