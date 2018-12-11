
import sequtils
import strutils
import streams
import re

type
    Vec2 = object
        x:int
        y:int
    Box = object
        lo:Vec2
        hi:Vec2
    Particle = object
        pos:Vec2
        vel:Vec2

proc at(p: Particle, time: int): Vec2 =
    return Vec2(x: p.pos.x+p.vel.x*time, y: p.pos.y+p.vel.y*time)

proc incl(b: var Box, p:Vec2) =
    b.lo.x = min(b.lo.x, p.x)
    b.lo.y = min(b.lo.y, p.y)
    b.hi.x = max(b.hi.x, p.x)
    b.hi.y = max(b.hi.y, p.y)

proc smallerThan(a: Box, b: Box): bool =
    return (a.hi.y-a.lo.y) < (b.hi.y-b.lo.y)

proc parseParticle(line: string):Particle =
    let reg = re"position=<\s*(-?\d+),\s*(-?\d+)>\s+velocity=<\s*(-?\d+),\s*(-?\d+)>"
    if line =~ reg:
        let m = map(matches[0..3], parseInt)
        let pos = Vec2(x: m[0], y: m[1])
        let vel = Vec2(x: m[2], y: m[3])
        return Particle(pos: pos, vel: vel)

proc boundsAt(particles: seq[Particle], time:int):Box =
    let init = particles[0].at(time)
    var box = Box(lo:init, hi:init)
    for particle in particles:
        box.incl( particle.at(time) )
    return box

proc main() =
    let inp = map(open("input10.txt").readAll().strip().split("\n"), parseParticle)
    var best = inp.boundsAt(0)
    for i in countup(1,100000):
        let c = inp.boundsAt(i)
        if c.smallerThan(best):
            best = c
        else:
            echo "At time ", i-1
            break

main()
