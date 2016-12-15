

module Day05

open System.Security.Cryptography
let hasher = MD5.Create()
let interesting key i =
    let h =
        sprintf "%s%i" key i
        |> System.Text.Encoding.ASCII.GetBytes
        |> hasher.ComputeHash
    if h.[0]=0uy && h.[1]=0uy && h.[2]<16uy then
        Some (int h.[2], int h.[3]/16)
    else
        None
let part1 keys =
    Seq.take 8 keys
    |> Seq.map (fst >> (sprintf "%x"))
    |> String.concat ""

let part2 keys =
    let code = Array.create 8 ' '
    let decode (pos, num) =
        if pos < 8 && code.[pos]=' ' then
            printfn "%i %i" pos num
            Array.set code pos (sprintf "%x" num).[0]
            match Array.tryFind (fun x -> x = ' ') code with
            | None -> Some code
            | _ -> None
        else
            None
    Seq.pick decode keys
    |> Seq.map (sprintf "%c")
    |> String.concat ""

//    |> Array.ofSeq
//let part1 key =
//            //        yeld (sprintf "%u" h.[2])
//    //|> Array.ofSeq
//    |> printfn "%A"
//
    //Seq.find () seq{1..}
let run() =
    let keys =
        Seq.initInfinite id
        |> Seq.choose (interesting "wtnhxymk")
        |> Seq.cache
    printfn "Part1 %s" (part1 keys)
    printfn "Part2 %s" (part2 keys)
    //printfn "Part2 %A" (part2 keys)
