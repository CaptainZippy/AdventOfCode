
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input02.txt").readAll().strip().split(","), parseInt)

proc run_code(mem: var seq[int]): int =
    var pc = 0
    while true:
        let op = mem[pc]
        if op == 99:
            echo mem
            return mem[0]
        assert op==1 or op==2
        let
            a1 = mem[pc+1]
            a2 = mem[pc+2]
            a3 = mem[pc+3]
        if op==1:
            mem[a3] = mem[a1] + mem[a2]
        else:
            mem[a3] = mem[a1] * mem[a2]
        pc += 4

#var prog = @[
    #1,0,0,0,99
    #2,3,0,3,99
    #2,4,4,5,99,0
    #1,1,1,4,99,5,6,0,99
#    ]
var prog = read_seq()
prog[1] = 12
prog[2] = 2
echo prog
echo run_code(prog)
echo prog