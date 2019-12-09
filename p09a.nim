
import strutils
import sequtils
import sugar
import tables
import strformat

proc read_seq(): seq[int64] =
    return map( open("input09.txt").readAll().strip().split(","), parseBiggestInt)

type
    Machine = object
        mem: Table[int64, int64]
        pc: int64
        input: seq[int64]
        inpos: int
        output: seq[int64]
        relbase: int64
    Mode = enum
        Pos=0, Imm, Rel
    OpCode = enum
        Add=1, Mul, Input, Output, JumpNE, JumpEQ, CmpLT, CmpEQ, RelAdd, Exit=99

proc newMachine(text: openarray[int64]) : Machine =
    var m = Machine()
    for i,t in text.pairs():
        m.mem[i] = t
    m.pc = 0
    m.relbase = 0
    return m

proc decode_op(m: var Machine): (OpCode, Mode, Mode, Mode) =
    let
        opmod = m.mem[m.pc]
        m1 = Mode((opmod div 100) mod 10)
        m2 = Mode((opmod div 1000) mod 10)
        m3 = Mode((opmod div 10000) mod 10)
    return (OpCode(opmod mod 100), m1,m2,m3)


proc cell(m: var Machine, pos: int64, mode: Mode) : int64 =
    case mode
        of Pos:
            return m.mem.getOrDefault( pos, 0 )
        of Imm:
            return pos
        of Rel:
            return m.mem.getOrDefault( pos, 0 ) + m.relbase

proc load(m: var Machine, pcoff:int, mode: Mode) : int64 =
    m.mem.getOrDefault( m.cell(m.pc + pcoff, mode), 0)

proc store(m: var Machine, pcoff:int, mode: Mode, val: int64) : void =
    m.mem[ m.cell(m.pc + pcoff, mode) ] = val

proc run(m: var Machine) : void =
    while true:
        let (opcode,m1,m2,m3) = m.decode_op()
        #echo fmt"PC {m.pc} {opcode} {m1} {m2} {m3}"
        case opcode:
        of OpCode.Add:
            m.store(3,m3, m.load(1,m1) + m.load(2,m2))
            m.pc += 4
        of OpCode.Mul:
            m.store(3,m3, m.load(1,m1) * m.load(2,m2))
            m.pc += 4
        of OpCode.Input:
            m.store(1,m1, m.input[m.inpos])
            m.inpos += 1
            m.pc += 2
        of OpCode.Output:
            m.output.add( m.load(1,m1) )
            m.pc += 2
        of OpCode.JumpNE:
            if m.load(1,m1) != 0:
                m.pc = m.load(2,m2)
            else:
                m.pc += 3
        of OpCode.JumpEQ:
            if m.load(1,m1) == 0:
                m.pc = m.load(2,m2)
            else:
                m.pc += 3
        of OpCode.CmpLT:
            let b = m.load(1,m1) < m.load(2,m2)
            m.store(3,m3, b.int64)
            m.pc += 4
        of OpCode.CmpEQ:
            let b = m.load(1,m1) == m.load(2,m2)
            m.store(3,m3, b.int64)
            m.pc += 4
        of OpCode.RelAdd:
            m.relbase += m.load(1,m1)
            m.pc += 2
        of OpCode.Exit:
            return

proc test64(
    mem: openarray[int64],
    input: openarray[int64],
    output: openarray[int64],
    custom: proc(m: Table[int64,int64]):bool = nil ): void =
    var m = newMachine(mem);
    m.input = input.toSeq
    m.run()
    assert output == m.output, fmt"{output} {m.output}"
    if custom != nil:
        assert(custom(m.mem))
    echo "OK", mem

proc test[T,S,U](
    mem: openarray[T],
    input: openarray[S],
    output: openarray[U],
    custom: proc(m: Table[int64,int64]):bool = nil ): void =
    test64( map(mem, x => x.int64), map(input, x => x.int64), map(output, x => x.int64), custom)

proc i64a( args: varargs[int64] ) : seq[int64] =
    map(args, x => x.int64)

proc test_all():void =
    let none:seq[int64] = @[]
    test([109, -1,   4, 1, 99], none, [-1])
    test([109, -1, 104, 1, 99], none, [1])
    test([109, -1, 204, 1, 99], none, [109])

    let quine = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    test(quine, none, quine)

    test([1102,34915192,34915192,7,4,7,99,0], none, [1219070632396864])
    test(i64a(104,1125899906842624,99), none, [1125899906842624])

        # test([1,0,0,0,99], [], [], (m) => m[0]==2)
        # test([2,3,0,3,99], [], [], (m) => m[3]==6)
        # test([2,4,4,5,99,0], [], [], (m) => m[5]==9801)
        # test([1,1,1,4,99,5,6,0,99], [], [], (m) => m[0]==30 and m[4]==2)

        # test([3,9,8,9,10,9,4,9,99,-1,8], [4], [0]) #ind eq 8
        # test([3,9,8,9,10,9,4,9,99,-1,8], [8], [1]) #ind eq 8

        # test([3,9,7,9,10,9,4,9,99,-1,8], [1], [1]) #ind lt 8
        # test([3,9,7,9,10,9,4,9,99,-1,8], [8], [0]) #ind lt 8
        # test([3,9,7,9,10,9,4,9,99,-1,8], [11], [0]) #ind lt 8

        # test([3,3,1108,-1,8,3,4,3,99], [3],[0]) #imm eq 8
        # test([3,3,1108,-1,8,3,4,3,99], [8],[1]) #imm eq 8

        # test([3,3,1107,-1,8,3,4,3,99], [7],[1]) #imm lt 8
        # test([3,3,1107,-1,8,3,4,3,99], [17],[0]) #imm lt 8

        # test([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [22],[1]) #tobool
        # test([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [0],[0]) #tobool

        # test([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [22],[1]) #tobool
        # test([3,3,1105,-1,9,1101,0,0,12,4,12,99,1], [0], [0]) #tobool

        # test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [-1],[999])
        # test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [8],[1000])
        # test([3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], [18],[1001])

proc main(): void =
    test_all()
    let prog = read_seq()
    var m = newMachine(prog)
    m.input.add(2)
    m.run()
    echo m.output

main()
quit(0)