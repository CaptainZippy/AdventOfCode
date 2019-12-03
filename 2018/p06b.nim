
import strutils
import sequtils
import streams
 
type Point = tuple
    x:int
    y:int

proc readSeeds(): seq[Point] =
    proc parsePoint(s:string): Point =
        let vals = s.split(',')
        return (vals[0].strip.parseInt(), vals[1].strip.parseInt())
    return map( open("input06.txt").readAll().strip().split("\n"), parsePoint)

const
    xmax = 355
    ymax = 355

proc main() =
    let seeds = readSeeds()
    var inside = 0
    for y in countup(1,ymax-1):
        for x in countup(1,xmax-1):
            var tot = 0
            for s in seeds:
                tot += abs(s.x-x) + abs(s.y-y)
            if tot < 10000:
                inside += 1
    echo inside

main()
