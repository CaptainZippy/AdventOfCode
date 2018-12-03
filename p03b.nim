
import strutils
import re

type
    Rect = tuple[claim:int, x:int, y:int, w:int, h:int]

proc claims(): seq[Rect] =
    let reg = re"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)"
    var ret: seq[Rect] = @[]
    for line in open("input03.txt").readAll().strip().split("\n"):
        if line =~ reg:
            let claim = matches[0].parseInt()
            let x = matches[1].parseInt()
            let y = matches[2].parseInt()
            let w = matches[3].parseInt()
            let h = matches[4].parseInt()
            let rr:Rect = (claim, x,y,w,h)
            ret.add( rr )
    return ret

proc main() =
    var fabric:array[0..999, array[0..999,int]]
    var count = 0
    for rect in claims():
        for j in countup(rect.y,rect.y+rect.h-1):
            for i in countup(rect.x,rect.x+rect.w-1):
                if fabric[j][i] == 0:
                    fabric[j][i] = rect.claim
                elif fabric[j][i] > 0:
                    fabric[j][i] = -1
                    count += 1
    for rect in claims():
        var ok = true
        for j in countup(rect.y,rect.y+rect.h-1):
            for i in countup(rect.x,rect.x+rect.w-1):
                if fabric[j][i] != rect.claim:
                    ok = false # break
        if ok:
            echo rect.claim
main()
