import strutils
import tables

type
    Body = ref object
        name: string
        parent: Body
        children: seq[Body]
        depth: int

proc findOrCreate(bodies: TableRef[string,Body], name: string): Body =
    var b = bodies.getOrDefault(name, nil)
    if b == nil:
        b = Body(name:name)
        bodies.add(name, b)
        #echo "+", name, repr(b)
    return b

proc read_solar(): void =
    var bodies = newTable[string,Body]()
    # Create hierarchy
    for line in open("input06.txt").readAll().strip().split("\n"):
        var bits = line.split(")")
        var a = bodies.findOrCreate(bits[0])
        var b = bodies.findOrCreate(bits[1])
        a.children.add(b)
        b.parent = a
    # Assign depths
    let COM = bodies.findOrCreate("COM")
    var todo = newSeq[(Body,int)]()
    todo.add( (COM, 0) )
    while todo.len() != 0:
        var (b,d) = todo.pop()
        b.depth = d
        for c in b.children:
            todo.add( (c,d+1) )
    # Compute hops
    var you = bodies.findOrCreate("YOU")
    var san = bodies.findOrCreate("SAN")
    var hops = 0
    while you.parent != san.parent:
        if you.depth > san.depth:
            you = you.parent
        else:
            san = san.parent
        hops += 1
    echo hops


read_solar()
