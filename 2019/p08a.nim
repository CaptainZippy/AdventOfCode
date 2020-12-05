
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
    orig = read_seq()
    npixels = 25 * 6
block:
    var i = 0
    while i < orig.len():
        let j = i + npixels
        frames.add( orig[i..<j])
        i = j

echo min( enumerate do:
    for f in frames:
        yield (f.count(0), f.count(1)*f.count(2)) )
