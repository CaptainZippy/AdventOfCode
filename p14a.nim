
import sequtils

proc main() =
    var work = newSeq[int]()
    var elf0 = 0
    var elf1 = 1
    work.add(3)
    work.add(7)
    let lim = 890691
    while len(work) < (lim+10):
        #echo work, " ", elf0, " ", elf1
        let sum = work[elf0]+work[elf1]
        if sum >= 10:
            work.add( sum div 10)
        work.add(sum mod 10)
        elf0 = (elf0 + work[elf0] + 1) mod work.len()
        elf1 = (elf1 + work[elf1] + 1) mod work.len()
    echo work[lim..lim+9]

main()
