
import strutils
import sequtils
import streams
 
proc valueNode(inp:seq[int], cur:var int):int =
    let numChildren = inp[cur+0]
    let numMeta = inp[cur+1]
    cur += 2
    if numChildren == 0:
        var tot = 0
        for i in countup(0,numMeta-1):
            tot += inp[cur+i]
        cur += numMeta
        return tot
    else:
        var tab = newSeq[int]()
        for i in countup(1,numChildren):
            tab.add( valueNode(inp, cur) )
        var tot = 0
        for i in countup(0,numMeta-1):
            try:
                tot += tab[ inp[cur+i]-1 ]
            except IndexError:
                continue
        cur += numMeta
        return tot

proc main() =
    let inp = map(open("input08.txt").readAll().strip().split(), parseInt)
    var pos = 0
    echo valueNode(inp, pos)

main()
