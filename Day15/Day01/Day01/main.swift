import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day15/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

var world = [[String]]()

var traveled = [[Int]]()
var bestPath : [(Int, Int)]? = nil
var bestPathLength = Int.max
var suggestedTarget = [(Int, Int)]()

func path(from: Thing, to: Thing, withMaxMoves: Int, inWorld: [[String]], pathSoFar: [(Int, Int)] = []) -> [(Int, Int)]? {
    if pathSoFar.count == 0 {
        bestPath = nil
        bestPathLength = Int.max
        traveled = []
        for (y, line) in world.enumerated() {
            traveled.append([])
            for _ in line {
                traveled[y].append(Int.max)
            }
        }
    }
    
    if traveled[from.y][from.x] < pathSoFar.count {
        return nil
    } else {
        traveled[from.y][from.x] = pathSoFar.count
    }
    
    let distance = abs(to.x - from.x) + abs(to.y - from.y)
    if distance == 1 {
        return pathSoFar
    } else if !to.targetable(world: inWorld) {
        return nil
    } else if distance > withMaxMoves || distance > bestPathLength {
        return nil
    } else if pathSoFar.count > bestPathLength || pathSoFar.count > withMaxMoves {
        return nil
    } else {
        if inWorld[from.y - 1][from.x] == "." {
            var newWorld = inWorld
            let fromCopy = from.copy()
            var newPath = pathSoFar
            newWorld[fromCopy.y][fromCopy.x] = "."
            fromCopy.y -= 1
            if !pathSoFar.contains(where: {$0.0 == fromCopy.x && $0.1 == fromCopy.y}) {
                newWorld[fromCopy.y][fromCopy.x] = from.type
                newPath.append((fromCopy.x, fromCopy.y))
                if let tryPath = path(from: fromCopy, to: to, withMaxMoves: withMaxMoves, inWorld: newWorld, pathSoFar: newPath) {
                    if tryPath.count < bestPathLength {
                        bestPath = tryPath
                        bestPathLength = tryPath.count
                    }
                }
            }
        }
        if inWorld[from.y][from.x - 1] == "." {
            var newWorld = inWorld
            let fromCopy = from.copy()
            var newPath = pathSoFar
            newWorld[fromCopy.y][fromCopy.x] = "."
            fromCopy.x -= 1
            if !pathSoFar.contains(where: {$0.0 == fromCopy.x && $0.1 == fromCopy.y}) {
                newWorld[fromCopy.y][fromCopy.x] = from.type
                newPath.append((fromCopy.x, fromCopy.y))
                if let tryPath = path(from: fromCopy, to: to, withMaxMoves: withMaxMoves, inWorld: newWorld, pathSoFar: newPath) {
                    if tryPath.count < bestPathLength {
                        bestPath = tryPath
                        bestPathLength = tryPath.count
                    }
                }
            }
        }
        if inWorld[from.y][from.x + 1] == "." {
            var newWorld = inWorld
            let fromCopy = from.copy()
            var newPath = pathSoFar
            newWorld[fromCopy.y][fromCopy.x] = "."
            fromCopy.x += 1
            if !pathSoFar.contains(where: {$0.0 == fromCopy.x && $0.1 == fromCopy.y}) {
                newWorld[fromCopy.y][fromCopy.x] = from.type
                newPath.append((fromCopy.x, fromCopy.y))
                if let tryPath = path(from: fromCopy, to: to, withMaxMoves: withMaxMoves, inWorld: newWorld, pathSoFar: newPath) {
                    if tryPath.count < bestPathLength {
                        bestPath = tryPath
                        bestPathLength = tryPath.count
                    }
                }
            }
        }
        if inWorld[from.y + 1][from.x] == "." {
            var newWorld = inWorld
            let fromCopy = from.copy()
            var newPath = pathSoFar
            newWorld[fromCopy.y][fromCopy.x] = "."
            fromCopy.y += 1
            if !pathSoFar.contains(where: {$0.0 == fromCopy.x && $0.1 == fromCopy.y}) {
                newWorld[fromCopy.y][fromCopy.x] = from.type
                newPath.append((fromCopy.x, fromCopy.y))
                if let tryPath = path(from: fromCopy, to: to, withMaxMoves: withMaxMoves, inWorld: newWorld, pathSoFar: newPath) {
                    if tryPath.count < bestPathLength {
                        bestPath = tryPath
                        bestPathLength = tryPath.count
                    }
                }
            }
        }
    }
    return bestPath
}

var travelMap = [[Int]]()
func travelMapfor(x: Int, y: Int, world: [[String]]) -> [[Int]] {
    travelMap = []
    for (y, line) in world.enumerated() {
        travelMap.append([])
        for _ in line {
            travelMap[y].append(Int.max)
        }
    }
    traversMapFor(x: x, y: y, world: world, path: [])
    return travelMap
 }

func traversMapFor(x: Int, y: Int, world: [[String]], path: [(Int, Int)]) {
    if travelMap[y][x] < path.count {
        return
    }
    travelMap[y][x] = path.count
    if world[y-1][x] == "." {
        var newPath = path
        newPath.append((x, y-1))
        traversMapFor(x: x, y: y-1, world: world, path: newPath)
    }
    if world[y][x-1] == "." {
        var newPath = path
        newPath.append((x-1, y))
        traversMapFor(x: x-1, y: y, world: world, path: newPath)
    }
    if world[y][x+1] == "." {
        var newPath = path
        newPath.append((x+1, y))
        traversMapFor(x: x+1, y: y, world: world, path: newPath)
    }
    if world[y+1][x] == "." {
        var newPath = path
        newPath.append((x, y+1))
        traversMapFor(x: x, y: y+1, world: world, path: newPath)
    }
}

func readOrder(arg1: Thing, arg2: Thing) -> Bool {
    if arg1.y == arg2.y {
        return arg1.x < arg2.x
    }
    return arg1.y < arg2.y
}

func readOrder(arg1: (Thing, [(Int, Int)]), arg2: (Thing, [(Int, Int)])) -> Bool {
    let tar1 = arg1.1.last!
    let tar2 = arg2.1.last!
    if tar1.1 == tar2.1 {
        return tar1.0 < tar2.0
    }
    return tar1.1 < tar2.1
}

var elves = [Thing]()
var goblins = [Thing]()

var id = 0
var y = 0
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

print("\n\n")
print(elves)
print(goblins)
for line in world {
    print(line)
}
var round = 0
print("")
for line in travelMapfor(x: 11, y: 2, world: world) {
    print(line)
}
//while (elves.count > 0 && goblins.count > 0) {
//    //do iter
//    var orderedThings = elves + goblins
//    orderedThings.sort(by: readOrder)
//
//    var killed = [Int]()
//    for thing in orderedThings {
//        if killed.contains(thing.id) { continue }
//        print("start \(thing.id)")
//        let aliveElves = elves.filter{!killed.contains($0.id)}
//        let aliveGoblins = goblins.filter{!killed.contains($0.id)}
//        if let kill = thing.takeTurn(elves: aliveElves, goblins: aliveGoblins, world: &world) {
//            print("KILLED \(kill)")
//            killed.append(kill)
//        }
//    }
//    for kill in killed {
//        if let index = elves.firstIndex(where: {kill == $0.id}) {
//            elves.remove(at: index)
//        }
//        if let index = goblins.firstIndex(where: {kill == $0.id}) {
//            goblins.remove(at: index)
//        }
//    }
//
//    round += 1
//    print("\nAfter Round \(round)")
//    print(elves)
//    print(goblins)
//    for line in world {
//        print(line)
//    }
//}
