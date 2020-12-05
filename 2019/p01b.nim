
import strutils
import sequtils

proc read_seq(): seq[int] =
    return map( open("input01.txt").readAll().strip().split("\n"), parseInt)

proc fuel_required(mass: int): int =
    return (mass div 3) - 2

proc fuel_required_rec(mass: int): int =
    var total = 0
    var m = mass
    while true:
        let t = fuel_required(m)
        if t > 0:
            total += t
            m = t
        else:
            break
    return total

echo foldl( map( read_seq(), fuel_required_rec), a + b, 0 )
