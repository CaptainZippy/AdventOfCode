
module Day04
let run() =
    let lines = System.IO.File.ReadAllLines("day04.txt")
    let decrypt str rot =
        let _a, _z = int 'a', int 'z'
        let dec c =
            match c with
            | a when a >= 'a' && a <= 'z' -> (char (( (int a) - _a + rot) % (_z-_a+1) + _a))
            | '-' -> ' '
            | c -> c
        Seq.map dec str
    let strFromChrs sq = String.concat "" (Seq.map (fun (c:char) -> c.ToString()) sq)
    let search line =
        let m = System.Text.RegularExpressions.Regex.Match(line, "([^0-9]+)([0-9]+)\[([^\]]+)\]")
        if m.Success then
            let name = m.Groups.[1].Value
            let counts1 = Seq.countBy (fun c->c) (name.Replace( "-", ""))
            let counts2 = Seq.sortBy (fun (a,b)->(-b,a)) counts1
            let counts3 = Seq.take 5 counts2
            let counts4 = Seq.map (fun (a,b)->a) counts3
            let chk = strFromChrs counts4
            if true || chk = m.Groups.[3].Value then
                let rot = System.Int32.Parse(m.Groups.[2].Value)
                let n = strFromChrs (decrypt name rot)
//                if n.IndexOf("north") > 0 then
                Some( n, rot )
//                  else
//                    None
            else
                None
        else
            None
    //printfn "%A" (Seq.sum (Array.choose search lines))
    //printfn "%A" (Array.choose search lines)
    Array.map (fun a -> printfn "%A" a) (Array.choose search lines)


