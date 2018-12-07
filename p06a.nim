
import strutils
import sequtils
import sets

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
    const
        xmax = 355
        ymax = 355
    var grid:array[0..ymax, array[0..xmax,int]]
    echo grid
    for i,s in seeds:
        grid[s.y][s.x] = i+1
    var done = true
    for y in countup(1,ymax):
        for x in countup(1,xmax):
            if grid[y][x] == 0:
                var s = initSet( [grid[y+1][x], grid[y-1][x], grid[y][x-1], grid[y][x+1]] )
                s.excl(0)
                if len(s)==1:
                    grid[y][x] = s.pop()
                else:
                    grid[y][x] = 999

main()
