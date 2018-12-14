
import sequtils

proc main() =
    var work = newSeq[int]()
    var elf0 = 0
    var elf1 = 1
    work.add(3)
    work.add(7)
    #let want = @[5,1,5,8,9]
    #let want = @[0,1,2,4,5]
    let want = @[8,9,0,6,9,1]
    #var match = 0
    while true:
    #for i in countup(0,30):
        #echo work, " ", elf0, " ", elf1
        let sum = work[elf0]+work[elf1]
        if sum >= 10:
            work.add(sum div 10)
            if work.len()>=want.len() and work[^6..^1]==want:
                break
        work.add(sum mod 10)
        if work.len()>=want.len() and work[^6..^1]==want:
            break
        elf0 = (elf0 + work[elf0] + 1) mod work.len()
        elf1 = (elf1 + work[elf1] + 1) mod work.len()
    echo len(work)-6

main()
