
import strutils
import sequtils
import sets
import streams
import strformat
import random
import algorithm
import rdstdin
 

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
    regMax = 60
type
    Grid = array[0..ymax, array[0..xmax,int]]

proc writePpm(grid: Grid) =
    var r = initRand(1)
    var lut = newSeq[byte]()
    lut.add(0)
    lut.add(0)
    lut.add(0)
    for s in countup(1,regMax-1):
        lut.add(byte(r.next()))
        lut.add(byte(r.next()))
        lut.add(byte(r.next()))
    lut.add(255)
    lut.add(255)
    lut.add(255)
    var os = openFileStream("/mnt/c/Users/Stephen/Desktop/output06.ppm",fmWrite)
    os.writeLine("P6")
    os.writeLine(fmt"{xmax-1} {ymax-1}")
    os.writeLine("255")
    for y in countup(1,ymax-1):
        for x in countup(1,xmax-1):
            var i = grid[y][x]
            os.write( lut[3*i+0] )
            os.write( lut[3*i+1] )
            os.write( lut[3*i+2] )
    close(os)

proc populateGrid():Grid =
    let seeds = readSeeds()
    assert seeds.len() < regMax
    var grid:Grid
    for i,s in seeds:
        grid[s.y][s.x] = i+1 # 0 reserved for todo
    return grid

proc main() =
    var grid:Grid = populateGrid()
    var more = true
    var hist = newSeq[int](regMax)
    while more:
        #writePpm(grid)
        #let str = readLineFromStdin "Enter"
        more = false
        let prev = grid
        for y in countup(1,ymax-1):
            for x in countup(1,xmax-1):
                if prev[y][x] == 0:
                    var cells = [prev[y+1][x], prev[y-1][x], prev[y][x-1], prev[y][x+1]].filter(
                        proc(x:int):bool = x > 0 ).deduplicate()
                    if len(cells)==0: # not near an assigned area
                        continue
                    more = true
                    if len(cells)==1:
                        grid[y][x] = cells[0]
                        hist[cells[0]] += 1
                    else:
                        grid[y][x] = regMax-1

    # anything on the border will be infinite
    # so zero those areas
    for y in countup(1,ymax-1):
        hist[ grid[y][1]      ] = 0
        hist[ grid[y][xmax-1] ] = 0
    for x in countup(1,ymax-1):
        hist[ grid[1][x]      ] = 0
        hist[ grid[ymax-1][x] ] = 0
    echo max(hist) + 1 # histogram didn't account for the original seed point
            

main()
