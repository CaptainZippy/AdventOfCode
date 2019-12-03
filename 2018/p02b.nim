
import strutils
import sets

proc main() =
    var same = initSet[string]()
    for line in open("input02.txt").readAll().strip().split("\n"):
        for i in countup(0, line.len()-1):
            var x = line
            x[i] = '_'
            if same.containsOrIncl(x):
                echo x.replace("_","")
                return

main()

