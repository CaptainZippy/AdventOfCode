
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input01.txt").readAll().strip().split("\n"), parseInt)

echo foldl( read_seq(), a + b)
