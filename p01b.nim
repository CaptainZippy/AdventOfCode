
import strutils
import sets
import sequtils

proc repeated(): int =
    var seen = initSet[int]()
    seen.incl(0)
    var tot = 0
    let input = map( open("input01.txt").readAll().strip().split("\n"), parseInt)
    echo input
    while true:
        for i in input:
            tot += i
            if seen.contains(tot):
                return tot
            seen.incl(tot)

echo repeated()
