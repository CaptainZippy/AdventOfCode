
import strutils
import sequtils
import sugar
import tables
import strformat

proc read_seq(): seq[int] =
    return map( open("input09.txt").readAll().strip().split(","), parseInt)

type
    Machine = object
        mem: Table[int, int]
        pc: int
        input: seq[int]
        inpos: int
        output: seq[int]
        relbase: int
    Mode = enum Pos=0, Imm, Rel

proc newMachine(text: openarray[int]) : Machine =
    var m = Machine()
    for i,t in text.pairs():
        m.mem[i] = t
    m.pc = 0
    m.relbase = 0
    return m

proc load(m: var Machine, pos: int, mode: Mode) : int =
    let v1 = m.mem.getOrDefault( pos, 0 )
    case mode
        of Pos:
            return m.mem.getOrDefault( v1, 0 )
        of Imm:
            return v1
        of Rel:
            return m.mem.getOrDefault( v1 + m.relbase, 0 )

proc decode_vva(m: var Machine) : (int,int,int) =
    let
        opmod = m.mem[m.pc]
        mode1 = Mode((opmod div 100) mod 10)
        mode2 = Mode((opmod div 1000) mod 10)
        r1 = m.load(m.pc+1, mode1)
        r2 = m.load(m.pc+2, mode2)
        r3 = m.load(m.pc+3, Mode.Imm)
    assert opmod div 10000 == 0
    m.pc += 4
    return (r1, r2, r3)

proc decode_a(m: var Machine) : int =
    let
        opmod = m.mem[m.pc]
        r1 = m.load(m.pc+1,Mode.Imm)
    assert (opmod div 100) == 0
    m.pc += 2
    return r1

proc decode_v(m: var Machine) : int =
    let
        opmod = m.mem[m.pc]
        mode1 = Mode(opmod div 100)
        r1 = m.load(m.pc+1, mode1)
    assert (opmod div 1000) == 0
    m.pc += 2
    return r1

proc decode_vv(m: var Machine) : (int,int) =
    let
        opmod = m.mem[m.pc]
        mode1 = Mode((opmod div 100) mod 10)
        mode2 = Mode((opmod div 1000) mod 10)
        r1 = m.load(m.pc+1, mode1)
        r2 = m.load(m.pc+2, mode2)
    assert (opmod div 10000) == 0
    m.pc += 3
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
        of 9:
            let v1 = m.decode_v()
            m.relbase += v1
        of 99:
            return
        else:
            doAssert(false, "Invalid opcode")

proc test(
    mem: openarray[int],
    input: openarray[int],
    output: openarray[int],
    custom: proc(m: Table[int,int]):bool = nil ): void =
    var m = newMachine(mem);
    m.input = input.toSeq()
    m.run()
    assert output == m.output, fmt"{output} {m.output}"
    if custom != nil:
        assert(custom(m.mem))

proc test_all():void =
    let quine = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    test(quine, [], quine)

    #test([1102,34915192,34915192,7,4,7,99,0], [], [1219070632396864])
    #test([104,1125899906842624,99], [], [1125899906842624])

    test([1,0,0,0,99], [], [], (m) => m[0]==2)
    test([2,3,0,3,99], [], [], (m) => m[3]==6)
    test([2,4,4,5,99,0], [], [], (m) => m[5]==9801)
    test([1,1,1,4,99,5,6,0,99], [], [], (m) => m[0]==30 and m[4]==2)

    test([3,9,8,9,10,9,4,9,99,-1,8], [4], [0]) #ind eq 8
    test([3,9,8,9,10,9,4,9,99,-1,8], [8], [1]) #ind eq 8

    test([3,9,7,9,10,9,4,9,99,-1,8], [1], [1]) #ind lt 8
    test([3,9,7,9,10,9,4,9,99,-1,8], [8], [0]) #ind lt 8
    test([3,9,7,9,10,9,4,9,99,-1,8], [11], [0]) #ind lt 8

    test([3,3,1108,-1,8,3,4,3,99], [3],[0]) #imm eq 8
    test([3,3,1108,-1,8,3,4,3,99], [8],[1]) #imm eq 8

    test([3,3,1107,-1,8,3,4,3,99], [7],[1]) #imm lt 8
    test([3,3,1107,-1,8,3,4,3,99], [17],[0]) #imm lt 8

    test([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [22],[1]) #tobool
    test([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [0],[0]) #tobool

    test([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [22],[1]) #tobool
    test([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [0], [0]) #tobool

    test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [-1],[999])
    test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [8],[1000])
    test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [18],[1001])

proc main(): void =
    test_all()
    let prog = read_seq()
    var m = newMachine(prog)
    #m.run()
    echo m.output

main()
quit(0)