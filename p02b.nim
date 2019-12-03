
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input02.txt").readAll().strip().split(","), parseInt)

proc run_code(mem: var seq[int]): int =
    var pc = 0
    while true:
        let op = mem[pc]
        if op == 99:
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
let orig = read_seq()
for noun in countup(0,99):
    for verb in countup(0,99):
        var prog = orig
        prog[1] = noun
        prog[2] = verb
        if run_code(prog) == 19690720:
            echo noun*100+verb
            quit(0)
quit(1)
