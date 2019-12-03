
import re
import strutils
import sequtils
import algorithm

const gridSize = 151
type
    TurnDirection = enum
        turnLeft, turnStraight, turnRight
    MoveDirection = enum
        moveLeft, moveUp, moveRight, moveDown
    Cart = object
        y:int
        x:int
        t:TurnDirection
        m:MoveDirection
    Grid =
        array[0..gridSize, array[0..gridSize,char]]

proc cmp( a, b: Cart ): int =
    let cy = cmp(a.y,b.y)
    if cy!=0:
        return cy
    return cmp(a.x,b.x)

proc show(grid:Grid, carts:seq[Cart]) =
    var g = grid
    for c in carts:
        g[c.y][c.x] = @['<','^','>','v'][ord(c.m)]
    for l in g:
        echo l.join("")

let input = open("input13.txt").readAll()
let input2 = """
/->-\        
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/"""

proc main() =
    var carts = newSeq[Cart]()
    var grid:Grid
    if true:
        var x = 0
        var y = 0
        for c in input:
            if c=='\n':
                x = 0
                y += 1
            else:
                if c=='<':
                    grid[y][x] = '-'
                    carts.add( Cart(x:x,y:y, t:turnLeft, m:moveLeft ) )
                elif c=='>':
                    grid[y][x] = '-'
                    carts.add( Cart(x:x,y:y, t:turnLeft, m:moveRight ) )
                elif c=='^':
                    grid[y][x] = '|'
                    carts.add( Cart(x:x,y:y, t:turnLeft, m:moveUp) )
                elif c=='v':
                    grid[y][x] = '|'
                    carts.add( Cart(x:x,y:y, t:turnLeft, m:moveDown) )
                elif c==' ' or c=='\\' or c=='/' or c=='+' or c=='|' or c=='-':
                    grid[y][x] = c
                else:
                    assert false
                x += 1
        carts.sort(cmp)
        show(grid,carts)
    #for i in countup(0,20):
    while true:
        var used = grid
        carts.apply() do (c: var Cart):
            case c.m:
                of moveLeft: c.x -= 1
                of moveUp: c.y -= 1
                of moveRight: c.x += 1
                of moveDown: c.y += 1
            if used[c.y][c.x]=='X':
                echo "CRASH at ", c.x, ' ', c.y
                assert false
            used[c.y][c.x] = 'X'
            case grid[c.y][c.x]
                of '\\':
                    c.m = @[moveUp, moveLeft, moveDown, moveRight][ord(c.m)]
                of '+':
                    case c.t
                        of turnLeft:
                            c.m = @[moveDown, moveLeft, moveUp, moveRight][ord(c.m)]
                            c.t = turnStraight
                        of turnStraight:
                            c.t = turnRight
                        of turnRight:
                            c.m = @[moveUp, moveRight, moveDown, moveLeft][ord(c.m)]
                            c.t = turnLeft
                of '/':
                    c.m = @[moveDown, moveRight, moveUp, moveLeft][ord(c.m)]
                of '-', '|':
                    c.x += 0
                else:
                    assert false
        carts.sort(cmp)
        #show(grid,carts)

main()
