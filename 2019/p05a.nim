
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input05.txt").readAll().strip().split(","), parseInt)

proc mode_of(op :int, pos :int): int =
    return (op div pos) mod 10

proc run_code(mem: var seq[int]): int =
    var pc = 0
    proc load(mem: seq[int], pos:int, imm:int): int =
        if imm!=0: pos
        else: mem[pos]
    proc store(mem: var seq[int], pos:int, imm:int, val:int) : void =
        assert(imm==0)
        mem[pos] = val
    while true:
        let opmod = mem[pc]
        let
            op = opmod mod 100
            imm1 = mode_of(opmod, 100)
            imm2 = mode_of(opmod, 1000)
            imm3 = mode_of(opmod, 10000)
        echo opmod, "=", op, " ", imm1, " ", imm2, " ", imm3
        if op == 99:
            return mem[0]
        case op:
        of 1:
            store(mem, mem[pc+3], imm3, load(mem, mem[pc+1], imm1) + load(mem, mem[pc+2], imm2))
            pc += 4
        of 2:
            store(mem, mem[pc+3], imm3, load(mem, mem[pc+1], imm1) * load(mem, mem[pc+2], imm2))
            pc += 4
        of 3:
            store( mem, mem[pc+1], imm1, 1 ) #= 1 #parseInt(stdin.readLine())
            pc += 2
        of 4:
            echo "OUT", load( mem, mem[pc+1], imm1 )
            pc += 2
        else:
            quit(1)

#var prog = @[
    #1,0,0,0,99
    #2,3,0,3,99
    #2,4,4,5,99,0
    #1,1,1,4,99,5,6,0,99
#    ]
let orig = read_seq()
var prog = orig
echo "COD£", run_code(prog)
