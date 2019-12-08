
import strutils
import sequtils

template enumerate(s: untyped): untyped =
  block:
    iterator `~tmp`(): auto = s
    var result = newSeq[type(`~tmp`())]()
    for item in `~tmp`():
      add(result, item)
    result

proc read_seq(): seq[int] =
    return map( open("input08.txt").readAll().strip().toSeq(), proc (c:char):int = int(c)-int('0'))

var frames: seq[seq[int]]
let
    #orig = [0,2,2,2,1,1,2,2,2,2,1,2,0,0,0,0]
    #npixels = 4
    orig= read_seq()
    npixels = 25 * 6
block:
    var i = 0
    while i < orig.len():
        let j = i + npixels
        frames.add( orig[i..<j])
        i = j

for r in countup(0,6-1):
    for c in countup(0,25-1):
        var i = r*25+c
        for f in frames:
            if f[i]!=2:
                stdout.write(if f[i]==1: '*' else: ' ')
                break
    stdout.write("\n")