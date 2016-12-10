
module Day01 =
    let addx (ax,ay) (bx,by) =
        (ax+bx, ay+by)
    let decode (x,y) (step:string) =
        let fw2 =
            match step.[0] with
                | 'L' -> (-1*y, x)
                | 'R' -> (y, -1*x)
        Seq.init (System.Int32.Parse (step.Substring 1)) (fun _ -> fw2)
    let rec path (fw:int*int) (insns:seq<string>) =
        let head, tail = (Seq.head insns), (Seq.skip 1 insns)
        let steps = decode fw head
        if (Seq.isEmpty tail) then steps
        else Seq.append steps (path (Seq.head steps) tail) 
    let part1 steps =
        Seq.reduce addx steps
    let part2 steps =
        let places = Seq.scan addx (0,0) steps
        let known = System.Collections.Generic.HashSet()
        places |> Seq.find (known.Add >> not)
    let run() =
        let txt = System.IO.File.ReadAllText("day01.txt")
        let steps = path (0,1) (Seq.map (fun (x:string) -> x.Trim()) (txt.Split ','))
        printfn "%A %A" (part1 steps) (part2 steps)
        
module Day02 =
    let pad1 pos dir =
        match dir with
            | 'U' -> if pos-3 < 1 then pos else pos-3
            | 'D' -> if pos+3 > 9 then pos else pos+3
            | 'L' -> if pos%3 = 1 then pos else pos-1
            | 'R' -> if pos%3 = 0 then pos else pos+1
    let pad2 pos dir =
        let p = match dir with
            | 'U' -> if pos-5 < 1 then pos else pos-5
            | 'D' -> if pos+5 > 25 then pos else pos+5
            | 'L' -> if pos%5 = 1 then pos else pos-1
            | 'R' -> if pos%5 = 0 then pos else pos+1
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

module Day03 =
    let triple (line:string) =
        let t = Array.filter (Seq.isEmpty >> not) (line.Split ' ')
        Array.map System.Int32.Parse t
    let run() =
        let lines = System.IO.File.ReadAllLines("day03.txt")
        let triples = Array.map triple lines
        printfn "Part1 %A" triples
[<EntryPoint>]
let main argv =
    //Day01.run()
    //Day02.run()
    Day03.run()
    0