import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day15/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

var world = [[String]]()

var travelMap = [[Int]]()
func travelMapfor(x: Int, y: Int, world: [[String]]) -> [[Int]] {
    travelMap = []
    for (y, line) in world.enumerated() {
        travelMap.append([])
        for _ in line {
            travelMap[y].append(Int.max)
        }
    }
    travelMap[y][x] = 0
    traversMapFor(x: x, y: y, world: world, path: [])
    return travelMap
 }

func traversMapFor(x: Int, y: Int, world: [[String]], path: [(Int, Int)]) {
    let distance = path.count + 1
    let options = [(y-1, x), (y, x-1), (y, x+1), (y+1, x)]
    var moves = [(Int, Int)]()
    for (ny, nx) in options {
        if world[ny][nx] == "." && travelMap[ny][nx] > distance {
            travelMap[ny][nx] = distance
            moves.append((nx, ny))
        }
    }
    for (nx, ny) in moves {
        traversMapFor(x: nx, y: ny, world: world, path: path + [(nx, ny)])
    }
}

func readOrder(arg1: Thing, arg2: Thing) -> Bool {
    if arg1.y == arg2.y {
        return arg1.x < arg2.x
    }
    return arg1.y < arg2.y
}

func readOrder(arg1: (Thing, (Int, Int)), arg2: (Thing, (Int, Int))) -> Bool {
    let tar1 = arg1.1
    let tar2 = arg2.1
    if tar1.1 == tar2.1 {
        return tar1.0 < tar2.0
    }
    return tar1.1 < tar2.1
}

var midround = false
var elfdeath = 1
var round = 0
var elves = [Thing]()
var goblins = [Thing]()
while elfdeath > 0 {
    
    var id = 0
    var y = 0
    round = 0
    elves = []
    goblins = []
    world = []
    content.enumerateLines { line, _ in
        world.append([])
        for (x, char) in line.enumerated() {
            let spot = String(char)
            switch spot {
            case "G":
                goblins.append(Thing(id: id, type: spot, x: x, y: y))
            case "E":
                elves.append(Thing(id: id, type: spot, x: x, y: y))
            default:
                break
            }
            world[y].append(spot)
            id += 1
        }
        y += 1
    }
    
    elfdeath = 0
    Thing.elfPower += 1
    print("trying \(Thing.elfPower)")
    while (elfdeath == 0 && elves.count > 0 && goblins.count > 0) {
        //do iter
        var orderedThings = elves + goblins
        orderedThings.sort(by: readOrder)
        midround = false
        var killed = [Int]()
        for thing in orderedThings {
            if killed.contains(thing.id) { continue }
            let aliveElves = elves.filter{!killed.contains($0.id)}
            let aliveGoblins = goblins.filter{!killed.contains($0.id)}
            if aliveElves.count == 0 || aliveGoblins.count == 0 {
                midround = true
                break
            }
            if let kill = thing.takeTurn(elves: aliveElves, goblins: aliveGoblins, world: &world) {
                killed.append(kill)
            }
        }
        for kill in killed {
            if let index = elves.firstIndex(where: {kill == $0.id}) {
                elfdeath += 1
                elves.remove(at: index)
            }
            if let index = goblins.firstIndex(where: {kill == $0.id}) {
                goblins.remove(at: index)
            }
        }

        round += 1
    }
}

let goblinHP = goblins.reduce(0) { (hp, thing) -> Int in
    return hp + thing.hp
}

let elfHP = elves.reduce(0) { (hp, thing) -> Int in
    return hp + thing.hp
}
if midround {
    print("Midround: \(round)")
} else {
    print("After: \(round)")
}
print("\nGoblin HP: \(goblinHP)")
print("\nElf HP: \(elfHP)")
print("\nElf Power: \(Thing.elfPower)")
