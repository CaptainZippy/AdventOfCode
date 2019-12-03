
import strutils
import algorithm
import re

proc main() =
    let
        src = open("input05.txt").readAll().strip()
        src_len = src.len()
    var
        dst = newSeq[char](src_len)
        s = 0
        d = 0
    echo src_len
    while s < src_len:
        if (d > 0) and (int(dst[d-1]).xor(int(src[s])) == 32):
            d -= 1
            s += 1
        else:
            dst[d] = src[s]
            d += 1
            s += 1
    echo s, "=>", d

main()
