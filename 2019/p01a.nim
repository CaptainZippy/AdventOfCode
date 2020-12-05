
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input01.txt").readAll().strip().split("\n"), parseInt)

proc fuel_required(mass: int): int =
    return (mass div 3) - 2

echo foldl( map( read_seq(), fuel_required), a + b, 0 )
