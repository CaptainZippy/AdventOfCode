
import strutils
import sequtils

type Point = tuple
    x:int
    y:int

proc readSeeds(): seq[Point] =
    proc parsePoint(s:string): Point = 
        let vals = s.split(',')
        return (vals[0].strip.parseInt(), vals[1].strip.parseInt())
    return map( open("input06.txt").readAll().strip().split("\n"), parsePoint)

proc main() =
    let seeds = readSeeds()
    echo seeds

main()
