
import strutils
import sequtils
import algorithm
import re

proc retract(src:string):int =
    let src_len = src.len()
    var
        dst = newSeq[char](src_len)
        s = 0
        d = 0
    while s < src_len:
        if (d > 0) and (int(dst[d-1]).xor(int(src[s])) == 32):
            d -= 1
            s += 1
        else:
            dst[d] = src[s]
            d += 1
            s += 1
    return d

iterator loop():tuple[letter: char, size: int] =
    let orig = open("input05.txt").readAll().strip()
    for letter in countup('a', 'z'):
        let src = orig.filterIt( it.toLowerAscii() != letter )
        yield (letter, retract(cast[string](src)))

proc main() =
    echo foldl( toSeq(loop()),
        if a.size < b.size: a else: b )

main()
