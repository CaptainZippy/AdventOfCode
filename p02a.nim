
import strutils
import algorithm
import tables

proc main() =
    var count2 = 0
    var count3 = 0
    for line in open("input02.txt").readAll().strip().split("\n"):
        var count: array['a'..'z', int]
        for c in line:
            count[c] += 1
        if count.find(2) >= 0:
            count2 += 1
        if count.find(3) >= 0:
            count3 += 1
    echo count2*count3

main()
