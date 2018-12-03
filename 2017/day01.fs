
module Day01

let addx (ax,ay) (bx,by) =
    (ax+bx, ay+by)
let decode (x,y) (step:string) =
    let fw2 =
        match step.[0] with
            | 'L' -> (-1*y, x)
            | 'R' -> (y, -1*x)
            | _ -> failwith "Bad data"
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
        
