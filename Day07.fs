
module Day07

let has_abba str =
    let is_abba (a,b,c,d) =
        a=d && b=c && a<>b
    Seq.windowed 4 str
    |> Seq.map (fun a -> a.[0],a.[1],a.[2],a.[3])
    |> Seq.filter is_abba
    |> Seq.isEmpty = false

let evenOdd (arr:string[]) = //List.fold (fun x (l,r) -> x::r, l) sequence ([],[])
    let n = arr.Length - 1
    [| for i in 0..2..n -> arr.[i] |], [| for i in 1..2..n -> arr.[i] |]

let has_tls (str:string) =
    let seps = [| '['; ']' |]
    let incl,excl = (str.Split seps) |> evenOdd
    ((Seq.exists has_abba excl) |> not) && (Seq.exists has_abba incl)

let aba_seqs str =
    let is_aba (a,b,c) =
        a=c && a<>b
    Seq.windowed 3 str
    |> Seq.map (fun a -> a.[0],a.[1],a.[2])
    |> Seq.filter is_aba

let has_ssl (str:string) =
    let seps = [| '['; ']' |]
    let evn,odd = (str.Split seps) |> evenOdd
    let evenseq = Array.map aba_seqs evn |> Seq.concat |> Seq.map (fun (a,b,c)->(b,a,b))
    let oddset = Array.map aba_seqs odd |> Seq.concat |> Set.ofSeq
    Seq.exists (fun x -> Set.contains x oddset) evenseq

let count func arr =
    Array.fold (fun acc x -> acc + if func x then 1 else 0) 0 arr

let run() =
    let lines = System.IO.File.ReadAllLines("day07.txt")
    printfn "Part1 %i" (count has_tls lines)
    printfn "Part2 %i" (count has_ssl lines)

