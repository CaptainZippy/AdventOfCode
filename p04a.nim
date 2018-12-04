
import strutils
import algorithm
import re

proc events(): seq[string] =
    var lines = open("input04.txt").readAll().strip().split("\n")
    lines.sort( system.cmp[string] )
    return lines

proc main() =
    var fabric:array[0..999, array[0..999,int]]
    var guard = -1
    var time = 0
    for event in events():
        if event =~ re"\[\d+-\d+-\d+ \d+:(\d+)] (Guard #(\d+) begins shift|wakes up|falls asleep)":
            time = matches[0].parseInt()
            if matches[2].len > 0:
                guard = matches[2].parseInt()
            elif matches[1] == "wakes up":
                time += 1
        else:
            assert false

main()
