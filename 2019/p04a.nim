 
import strutils
import sequtils
import tables

proc isvalid(num:int): int =
    let s = intToStr(num)
    assert s.len == 6
    var rep = false
    for i in countup(1,5):
        if s[i] < s[i-1]:
            return 0
        elif s[i] == s[i-1]:
            rep = true
    if not rep:
        return 0
    return 1

proc test(num: int): void=
    echo (num, isvalid(num))

proc main():void =
    test(111111)
    test(223450)
    test(123789)
    var count = 0
    for i in countup(125730,579381):
        count += isvalid(i)
    echo count

main()