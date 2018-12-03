
import strutils
import re

proc main() =
    let reg = re"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)"
    var fabric:array[0..999, array[0..999,int]]
    var count = 0
    for line in open("input03.txt").readAll().strip().split("\n"):
        if line =~ reg:
            let claim = matches[0].parseInt()
            let x = matches[1].parseInt()
            let y = matches[2].parseInt()
            let w = matches[3].parseInt()
            let h = matches[4].parseInt()
            for j in countup(y,y+h-1):
                for i in countup(x,x+w-1):
                    if fabric[j][i] == 0:
                        fabric[j][i] = claim
                    elif fabric[j][i] > 0:
                        fabric[j][i] = -1
                        count += 1
        else:
            assert false
    echo count
main()
