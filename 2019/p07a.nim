
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input07.txt").readAll().strip().split(","), parseInt)

type
    Machine = object
        mem: seq[int]
        pc: int
        input: seq[int]
        inpos: int
        output: seq[int]

proc newMachine(mem: seq[int]) : Machine =
    var m = Machine()
    m.mem = mem
    m.pc = 0
    return m

proc decode_vva(m: var Machine) : (int,int,int) =
    let
        opmod = m.mem[m.pc]
        ind1 = ((opmod div 100) mod 10) == 0
        ind2 = ((opmod div 1000) mod 10) == 0
    assert opmod div 10000 == 0
    var
        r1 = m.mem[m.pc+1]
        r2 = m.mem[m.pc+2]
        r3 = m.mem[m.pc+3]
    m.pc += 4
    if ind1:
        r1 = m.mem[r1]
    if ind2:
        r2 = m.mem[r2]
    return (r1, r2, r3)

proc decode_a(m: var Machine) : int =
    let
        opmod = m.mem[m.pc]
    assert (opmod div 100) == 0
    var r1 = m.mem[m.pc+1]
    m.pc += 2
    return r1

proc decode_v(m: var Machine) : int =
    let
        opmod = m.mem[m.pc]
        ind1 = (opmod div 100) == 0
    assert (opmod div 1000) == 0
    var r1 = m.mem[m.pc+1]
    if ind1:
        r1 = m.mem[r1]
    m.pc += 2
    return r1

proc decode_vv(m: var Machine) : (int,int) =
    let
        opmod = m.mem[m.pc]
        ind1 = ((opmod div 100) mod 10) == 0
        ind2 = ((opmod div 1000) mod 10) == 0
    assert (opmod div 10000) == 0
    var
        r1 = m.mem[m.pc+1]
        r2 = m.mem[m.pc+2]
    m.pc += 3
    if ind1:
        r1 = m.mem[r1]
    if ind2:
        r2 = m.mem[r2]
    return (r1,r2)

proc run(m: var Machine) : void =
    while true:
        #echo "PC ", m.pc, " ", m.mem[m.pc]
        case m.mem[m.pc] mod 100:
        of 1: #add
            let (v1,v2,a1) = m.decode_vva()
            m.mem[a1] = v1+v2
        of 2: #mul
            let (v1,v2,a1) = m.decode_vva()
            m.mem[a1] = v1*v2
        of 3: #input
            let a1 = m.decode_a()
            m.mem[a1] = m.input[m.inpos]
            m.inpos += 1
        of 4: #output
            let v1 = m.decode_v()
            m.output.add(v1)
        of 5: #jne
            let (v1,a1) = m.decode_vv()
            if v1 != 0:
                m.pc = a1
        of 6: #jeq
            let (v1,a1) = m.decode_vv()
            if v1 == 0:
                m.pc = a1
        of 7: #lt
            let (v1,v2,a1) = m.decode_vva()
            m.mem[a1] = if v1 < v2: 1
                else: 0
        of 8: #eq
            let (v1,v2,a1) = m.decode_vva()
            m.mem[a1] = if v1 == v2: 1
                else: 0
        of 99:
            return
        else:
            quit(1)

var prog1 = @[
    #1,0,0,0,99
    #2,3,0,3,99
    #2,4,4,5,99,0
    #1,1,1,4,99,5,6,0,99
    #3,9,8,9,10,9,4,9,99,-1,8 #ind eq 8
    #3,9,7,9,10,9,4,9,99,-1,8 #ind lt 8
    #3,3,1108,-1,8,3,4,3,99 #imm eq 8
    #3,3,1107,-1,8,3,4,3,99 #imm lt 8
    #3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 #eq 0
    #3,3,1105,-1,9,1101,0,0,12,4,12,99,1 #eq 0
    3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    ]
var prog2 = @[
    #3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0 #43210 -> 43210
    #3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0 # 0,1,2,3,4 -> 54321
    3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0# 1,0,4,3,2 -> 65210
]
let prog = read_seq()
if false:
    for i,p in prog.pairs():
        echo i,":",p


proc calc1(src: int, phase: int): int =
    var mach = newMachine(prog)
    mach.input.add(phase)
    mach.input.add(src)
    mach.run()
    #echo "calc ", src, " ", phase, " = ", mach.output[0]
    return mach.output[0]

proc search(src: int, path: string, phases: seq[int]): (int,string) =
    #echo "S ", src, " ", path, " ", phases
    if phases.len == 0:
        return (src,path)
    var mx = 0
    var mp: string
    for i,phase in phases.pairs:
        let c = calc1(src, phase)
        var p2 = phases
        p2.del(i)
        let (v,p) = search(c, path & $phase, p2)
        if v > mx:
            mx = v
            mp = p
    #echo "S< ", mx, " ", mp
    return (mx,mp)

echo search(0, "", @[0,1,2,3,4])