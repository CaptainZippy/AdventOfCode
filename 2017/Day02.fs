module Day02

let pad1 pos dir =
    match dir with
    | 'U' -> if pos-3 < 1 then pos else pos-3
    | 'D' -> if pos+3 > 9 then pos else pos+3
    | 'L' -> if pos%3 = 1 then pos else pos-1
    | 'R' -> if pos%3 = 0 then pos else pos+1
    | _ -> failwith "Invalid"
let pad2 pos dir =
    let p =
        match dir with
        | 'U' -> if pos-5 < 1 then pos else pos-5
        | 'D' -> if pos+5 > 25 then pos else pos+5
        | 'L' -> if pos%5 = 1 then pos else pos-1
        | 'R' -> if pos%5 = 0 then pos else pos+1
        | _ -> failwith "Invalid"
    match p with
        |1|2|4|5|6|10|16|20|21|22|24|25 -> pos
        | _ -> p
let label1 s =
    s
let label2 s =
    "_..1...234.56789.ABC...D..".[s]
let rec decode padfunc (pos:int) (insns:seq<string>) =
    let head, tail = (Seq.head insns), (Seq.skip 1 insns)
    let pos2 = Seq.fold padfunc pos head
    if (Seq.isEmpty tail) then (Seq.singleton pos2)
    else Seq.append (Seq.singleton pos2) (decode padfunc pos2 tail)
let run() =
    let lines = System.IO.File.ReadAllLines("day02.txt")
    printfn "Part1 %A" (Array.ofSeq (Seq.map label1 (decode pad1 5 lines)))
    printfn "Part2 %A" (Array.ofSeq (Seq.map label2 (decode pad2 15 lines)))


