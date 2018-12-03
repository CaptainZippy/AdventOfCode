
module Day09

open System.Text.RegularExpressions

let (|Repeat|_|) input =
    let m = Regex.Match(input,@"^\((\d+)x(\d+)\)")
    if (m.Success) then
        let len,cnt = m.Groups.[1].Value, m.Groups.[2].Value
        let p = (fun c->System.Int32.Parse(c)) 
        Some (m.Length, p len, p cnt)
    else
        None

let (|Run|_|) input =
    let m = Regex.Match(input,@"([^\(]+)")
    if (m.Success) then
        Some m.Groups.[1].Value
    else
        None

let rec decode input =
    match input with
    | Repeat (ilen, mlen, mcnt)
        -> String.replicate mcnt (input.Substring(ilen,mlen)) :: decode (input.Substring(ilen+mlen))
    | Run txt
        -> txt :: decode (input.Substring(String.length txt))
    | ""
        -> [""]
    | _ 
        -> failwith "Parse error"

let rec decode_len input =
    match input with
    | Repeat (ilen, mlen, mcnt)
        -> bigint mcnt * decode_len (input.Substring(ilen,mlen)) + decode_len (input.Substring(ilen+mlen))
    | Run txt
        -> bigint (String.length txt) + decode_len (input.Substring(String.length txt))
    | ""
        -> bigint 0
    | _ 
        -> failwith "Parse error"

let run() =
    let input = System.IO.File.ReadAllText("day09.txt").Trim()
    //printfn "Part1 %A" (decode "A(1x5)BC")
    //printfn "Part1 %A" (decode "(3x3)XYZ")
    //printfn "Part1 %A" (decode "A(2x2)BCD(2x2)EFG")
    //printfn "Part1\n%i" ( 
    let txt = String.concat "" (decode input)
    printfn "Part1 %i" (String.length txt)
    printfn "Part2 %A" (decode_len txt)
    //printfn "Part2\n%s" ( sim lines |> screen)
    //printfn "Part2 %i" (count has_ssl lines)

