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
        var enemies = type == "G" ? elves : goblins
        var targets = [(Thing, [(Int,Int)])]()
        var targetDis = Int.max - 1
        enemies.sort { (first, second) -> Bool in
            let dist1 = abs(first.x - x) + abs(first.y - y)
            let dist2 = abs(second.x - x) + abs(second.y - y)
            return dist1 < dist2
        }
        for enemy in enemies {
            //distance calculation needs to be done¬
            print("from \(self) to \(enemy) with max \(targetDis)")
            if let path = path(from: self, to: enemy, withMaxMoves: targetDis, inWorld: world) {
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
            let mvTarget = targets[0].1.first!
            
            world[y][x] = "."
            x = mvTarget.0
            y = mvTarget.1
            world[y][x] = type
            targetDis -= 1
        }
        
        //attack
        if targetDis == 0 && targets.count > 0 {
            var option = targets.map{$0.0}
            option.sort{$0.hp != $1.hp ? $0.hp < $1.hp : ($0.y == $1.y ? $0.x < $1.x : $0.y < $1.y)}
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

print("\n\n")
print(elves)
print(goblins)
for line in world {
    print(line)
}
var round = 0
while (elves.count > 0 && goblins.count > 0) {
    //do iter
    var orderedThings = elves + goblins
    orderedThings.sort(by: readOrder)

    var killed = [Int]()
    for thing in orderedThings {
        if killed.contains(thing.id) { continue }
        print("start \(thing.id)")
        let aliveElves = elves.filter{!killed.contains($0.id)}
        let aliveGoblins = goblins.filter{!killed.contains($0.id)}
        if let kill = thing.takeTurn(elves: aliveElves, goblins: aliveGoblins, world: &world) {
            print("KILLED \(kill)")
            killed.append(kill)
        }
    }
    for kill in killed {
        if let index = elves.firstIndex(where: {kill == $0.id}) {
            elves.remove(at: index)
        }
        if let index = goblins.firstIndex(where: {kill == $0.id}) {
            goblins.remove(at: index)
        }
    }

    round += 1
    print("\nAfter Round \(round)")
    print(elves)
    print(goblins)
    for line in world {
        print(line)
    }
}
