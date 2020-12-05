import strutils
import sequtils
import tables

type
    Body = ref object
        name: string
        children: seq[Body]
        depth: int

proc findOrCreate(bodies: TableRef[string,Body], name: string): Body =
    var b = bodies.getOrDefault(name, nil)
    if b == nil:
        b = Body(name:name)
        bodies.add(name, b)
    return b

proc read_solar(): void =
    var bodies = newTable[string,Body]()
    for line in open("input06.txt").readAll().strip().split("\n"):
        var bits = line.split(")")
        var a = bodies.findOrCreate(bits[0])
        var b = bodies.findOrCreate(bits[1])
        a.children.add(b)
    let COM = bodies.findOrCreate("COM")
    var todo = newSeq[(Body,int)]()
    todo.add( (COM, 0) )
    var total = 0
    while todo.len() != 0:
        var (b,d) = todo.pop()
        total += d
        for c in b.children:
            todo.add( (c,d+1) )
    echo "SUM", total


read_solar()
