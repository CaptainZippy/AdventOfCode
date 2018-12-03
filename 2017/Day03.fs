module Day03
let triple (line:string) =
    let t = Array.filter (Seq.isEmpty >> not) (line.Split ' ')
    Array.map System.Int32.Parse t
let check (triples:int[][]) =
    let ok (y:int[]) =
        let x = Array.sort y
        x.[0]+x.[1] > x.[2]
    Array.filter ok triples
let transpose (triples:int[][]) =
    let func i =
        let c = i%3
        let r = i-c
        [|triples.[r].[c]; triples.[r+1].[c]; triples.[r+2].[c] |]
    Array.init triples.Length func
let run() =
    let lines = System.IO.File.ReadAllLines("day03.txt")
    let htriples = Array.map triple lines
    printfn "Part1 %A" (Array.length (check htriples))
    let vtriples = transpose htriples
    printfn "Part2 %A" (Array.length (check vtriples))
