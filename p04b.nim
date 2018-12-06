
import strutils
import sequtils
import algorithm
import tables
import re

proc events(): seq[string] =
    var lines = open("input04.txt").readAll().strip().split("\n")
    lines.sort( system.cmp[string] )
    return lines

proc main() =
    type Info = ref object
        count: int
        hist: array[60,int]
    var sleepstart = 0
    var times = newTable[int,Info]()
    var info:Info
    for event in events():
        if event =~ re"\[\d+-\d+-\d+ \d+:(\d+)] (Guard #(\d+) begins shift|wakes up|falls asleep)":
            if matches[2].len > 0:
                let guard = matches[2].parseInt()
                try:
                    info = times[guard]
                except KeyError:
                    info = new Info
                    times.add(guard, info)
            elif matches[1] == "falls asleep":
                sleepstart = matches[0].parseInt()
            elif matches[1] == "wakes up":
                let sleepend = matches[0].parseInt
                info.count += sleepend - sleepstart
                for i in countup(sleepstart, sleepend-1):
                    info.hist[i] += 1
        else:
            assert false
    let
        allpairs = toSeq(times.pairs())
        best = foldl( allpairs, if a[1].count>b[1].count: a else: b )
        hists = zip( toseq(countup[int](0,59)), best[1].hist )
        minute = foldl(hists, if a[1]>b[1]: a else: b)
    echo best[1].hist
    echo "Guard ", best[0], " for ", best[1].count, " minutes ", minute, " ", best[0] * minute[0]
    for k,v in times.pairs():
        let
            hists = zip( toseq(countup[int](0,59)), v.hist )
            minute = foldl(hists, if a[1]>b[1]: a else: b)
        echo k,minute

main()
