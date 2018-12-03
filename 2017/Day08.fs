
module Day08

open System.Text.RegularExpressions

let screen (data:byte[]) =
    let row i =
        data 
        |> Array.map (fun x-> if (x&&&(1uy<<<i)=0uy) then '.' else 'X')
        |> (fun x -> System.String(x))
    String.concat "\n" [|for i in 0..5 -> row i|]

let bitcount1 (c:int) =
    let rec f acc x =
        if x<>0 then
            f (acc+1) (x&&&(x-1))
        else
            acc
    f 0 c

let bitcount (data:byte[]) =
    Array.map (int >> bitcount1) data |> Array.sum

let sim insts =
    let data =
        Array.init 50 (fun i -> 0uy)

    let (|Integers|_|) pattern input =
        let m = Regex.Match(input,pattern) 
        if (m.Success) then
            let x,y = m.Groups.[1].Value, m.Groups.[2].Value
            let p = (fun c->System.Int32.Parse(c)) 
            Some (p x, p y)
        else
            None
    let rect (x,y) =
        let bits = (pown 2uy y) - 1uy
        for i in 0..x-1 do
            Array.set data i (data.[i] ||| bits)

    let rotr (row,amt) =
        let mbit = 1uy <<< row
        let rest = ~~~mbit
        let bits = Array.map (fun c -> (c&&&mbit)) data
        let move si _ =
            let di = (si+amt)%50
            Array.set data di ((data.[di] &&& rest) ||| (bits.[si]))
        Array.iteri move data
     
    let rotc (col,amt) =
        let o = data.[col]
        let n = ((o <<< amt) &&& 0x3fuy) ||| (o >>> (6-amt))
        Array.set data col n

    let exec inst =
        match inst with
        | Integers @"rect (\d+)x(\d+)" (x,y) -> rect(x,y)
        | Integers @"rotate row y=(\d+) by (\d+)" (x,y) -> rotr(x,y)
        | Integers @"rotate column x=(\d+) by (\d+)" (x,y) -> rotc(x,y)
        | _ -> failwith "parseerror"
    Array.iter exec insts
    data

let run() =
    let lines = System.IO.File.ReadAllLines("day08.txt")
    printfn "Part1\n%i" ( sim lines |> bitcount )
    printfn "Part2\n%s" ( sim lines |> screen)
    //printfn "Part2 %i" (count has_ssl lines)

