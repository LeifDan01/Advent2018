import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)


var world = [[String]]()
var spotsTravled = [(Int, Int)]()
var bestPath = [(Int, Int)]()
var bestPathLength = Int.max

func path(from: Thing, to: Thing, withMaxMoves: Int, in: [[String]], pathSoFar: [(Int, Int)] = []) -> [(Int, Int)]? {
    if pathSoFar.count == 0 {
        spotsTravled = []
        bestPath = []
        bestPathLength = Int.max
    }
    spotsTravled.append((from.x, from.y))

    let found : [(Int, Int)]?
    let distance = abs(to.x - from.x) + abs(to.y - from.y)
    if distance == 1 {
        return pathSoFar
//    } else if spotsTravled.contains(where: ((x, y) in return x == from.x && y == from.y)) {
//        return nil
    } else if !to.targetable(world: world) {
        return nil
    } else if distance > withMaxMoves {
        return nil
    } else {
        if world[from.y - 1][from.x] == "." {
            var newWorld = world
            var fromCopy = from.copy()
            var newPath = pathSoFar
            newPath.append((from.x, from.y))
            newWorld[fromCopy.y][fromCopy.x] = "."
            fromCopy.y -= 1
            newWorld[fromCopy.y][fromCopy.x] = from.type
            if let tryPath = path(from: fromCopy, to: to, withMaxMoves: withMaxMoves, in: newWorld, pathSoFar: newPath) {
                if tryPath.count <= bestPathLength {
                    bestPath = tryPath
                    bestPathLength = tryPath.count
                }
            }
        }
    }
    return found
}

class Thing : CustomStringConvertible {
    let id: Int
    let type: String
    var x : Int
    var y : Int
    var hp = 200

    init(id: Int, type: String, x: Int, y: Int) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
    }

    func copy() -> Thing {
        return Thing(id: id, type: type, x: x, y: y)
    }

    var description: String {
        return "\(type)\(id) at (\(x), \(y)) with \(hp)"
    }

//    func pathToMe(from: Thing, withMaxMoves: Int, world: [[String]], path: [(Int, Int)] = []) -> [(Int, Int)]? {
//        var found : [(Int, Int)]?
//        let distance = abs(x - from.x) + abs(y - from.y)
//        if distance == 1 {
//            return path
//        } else if !self.targetable(world: world) {
//            return nil
//        } else if distance > withMaxMoves {
//            return nil
//        } else {
//
//        }
//        return found
//    }

    func hit(world: inout [[String]]) -> Int? {
        hp -= 3
        if hp < 0 {
            world[y][x] = "."
            return id
        }
        return nil
    }

    func targetable(world: [[String]]) -> Bool {
        return world[y-1][x] == "." || world[y][x-1] == "." || world[y][x+1] == "." || world[y+1][x] == "."
    }

    func takeTurn(elves: [Thing], goblins: [Thing], world: inout [[String]]) -> Int? {
        //select target
        let enemies = type == "G" ? elves : goblins
        var targets = [(Thing, [(Int,Int)])]()
        var targetDis = Int.max - 1
        for enemy in enemies {
            //distance calculation needs to be done¬
            if let path = path(from: self, to: enemy, withMaxMoves: targetDis, in: world) {
                let distance = path.count
                if distance == targetDis {
                    targets.append((enemy, path))
                } else if distance < targetDis {
                    targets = [(enemy, path)]
                    targetDis = distance
                }
            }
        }

        //move
        if targetDis > 0 && targets.count > 0 {
            targets.sort(by: readOrder)
            let mvTarget = targets[0].1.last!

            world[y][x] = "."
            x = mvTarget.0
            y = mvTarget.1
            world[y][x] = type
        }

        //attack
        if targetDis == 0 && targets.count > 0 {
            // ? does this work
            var option = targets.map{$0.0}
            option.sort(by: readOrder)
            option.sort{$0.hp < $1.hp}
            return option[0].hit(world: &world)
        }
        return nil
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

print(elves)
print(goblins)
for line in world {
    print(line)
}

//for i in 1...70 {
//    //do iter
//    var orderedThings = elves + goblins
//    orderedThings.sort(by: readOrder)
//
//    var killed = [Int]()
//    for thing in orderedThings {
//        if killed.contains(thing.id) { continue }
////        if thing.id != 33 { continue }
//
//        if let kill = thing.takeTurn(elves: elves, goblins: goblins, world: &world) {
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
//    print("\n\(i)")
//    print(elves)
//    print(goblins)
//    for line in world {
//        print(line)
//    }
//}

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
    if travelMap[y][x] > path.count {
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
