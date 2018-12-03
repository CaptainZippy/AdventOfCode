
module Day10

open System.Text.RegularExpressions

type Bot =
    struct
        val mutable vallo:int
        val mutable valhi:int
        val mutable tgtlo:int
        val mutable tgthi:int
    end

let (|Initial|_|) input =
    let m = Regex.Match(input,@"value (\d+) goes to bot (\d+)")
    if (m.Success) then
        let value,bot = m.Groups.[1].Value, m.Groups.[2].Value
        let p = (fun c->System.Int32.Parse(c)) 
        Some (p value, p bot)
    else
        None

let (|Give|_|) input =
    let m = Regex.Match(input,@"bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)")
    if (m.Success) then
        let p = (fun c->System.Int32.Parse(c)) 
        Some (p m.Groups.[1].Value, m.Groups.[2].Value, p m.Groups.[3].Value, m.Groups.[4].Value, p m.Groups.[5].Value)
    else
        None

let rec decode input =
    match input with
    | Initial (value, bot)
        -> [""]
        //if state.Contains(value) then
         //   printfn
         //else
    | Give (bot, lowtgt, lownum, hitgt, hival)
        -> [""]//txt :: decode (input.Substring(String.length txt))
    | ""
        -> [""]
    | _ 
        -> failwith "Parse error"

let run() =
    let input = System.IO.File.ReadAllLines("day10.txt")
    printfn "Part1 %A" (Array.map decode input)

