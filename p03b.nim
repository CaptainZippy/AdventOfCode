 
import strutils
import sequtils
import tables

proc read_seqs(): (seq[string], seq[string]) =
    let f = open("input03.txt")
    let
        s0 = f.readline().strip().split(",")
        s1 = f.readline().strip().split(",")
    return (s0,s1)

iterator run_seq(path: seq[string], ident: int, tab: var Table[(int,int),(int,int)]): int =
    var pos = (0,0)
    var cost = 0
    for p in path:
        let s = case p[0]:
            of 'L': (-1,0)
            of 'R': ( 1,0)
            of 'D': (0,-1)
            of 'U': (0, 1)
            else: quit(1)
        let l = parseInt p[1 .. p.high]
        for i in countup(1, l):
            cost += 1
            pos = (pos[0]+s[0], pos[1]+s[1])
            var c = tab.getOrDefault(pos, (0,0))
            if ident==0:
                if c[0] == 0:
                    c[0] = cost
                    tab[pos] = c
            else:
                if c[1] == 0:
                    c[1] = cost
                    tab[pos] = c
                if c[0] != 0:
                    yield c[0] + c[1]

#let seq0 = "R8,U5,L5,D3".split(",")
#let seq1 = "U7,R6,D4,L4".split(",")
#let seq0 = "R75,D30,R83,U83,L12,D49,R71,U7,L72".split(",")
#let seq1 = "U62,R66,U55,R34,D71,R55,D58,R83".split(",")
#let seq0 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51".split(",")
#let seq1 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".split(",")
let (seq0,seq1) = read_seqs()
var tab = initTable[(int,int),(int,int)]()
for i in run_seq(seq0, 0, tab):
    echo "0 ", i
for i in run_seq(seq1, 1, tab):
    echo "1 ", i
#echo foldl( run_seq(seq1, 1, tab).toSeq(), min(a,b) ) #TODO min of iterator


