
import sequtils
import strutils
import streams
 
proc countMeta(inp:seq[int], cur:var int):int =
    let numChildren = inp[cur+0]
    let numMeta = inp[cur+1]
    cur += 2
    var tot = 0
    for i in countup(1,numChildren):
        tot += countMeta(inp, cur)
    for i in countup(0,numMeta-1):
        tot += inp[cur+i]
    cur += numMeta
    return tot

proc main() =
    let inp = map(open("input08.txt").readAll().strip().split(), parseInt)
    var pos = 0
    echo countMeta( inp, pos)

main()
