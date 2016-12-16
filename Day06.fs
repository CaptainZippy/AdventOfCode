
module Day06

let run() =
    let ecc func (lines:string[]) =
        let extract s =
            Seq.countBy id s
            |> func snd 
            |> fst
        Array.map extract lines
    let lines =
        System.IO.File.ReadAllLines("day06.txt")
    let nrow,ncol = lines.Length, lines.[0].Length
    let cols = Array.init ncol (fun c ->
        String.init nrow (fun r -> lines.[r].[c].ToString()))
    printfn "Part1 %A" (ecc Seq.maxBy cols)
    printfn "Part2 %A" (ecc Seq.minBy cols)


