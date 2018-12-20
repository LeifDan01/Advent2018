//import UIKit
//
//let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
//let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
//
//var world = [[String]]()
//var lineNum = 0
//content.enumerateLines { line, _ in
//    world.append([])
//    for char in line {
//        world[lineNum].append(String(char))
//    }
//    lineNum += 1
//}
//var newWorld = [[String]]()
//let maxX = world[0].count
//let maxY = world.count
//for minute in 1...10 {
//    newWorld = [[String]]()
//    for (y, line) in world.enumerated() {
//        newWorld.append([])
//        for (x, entry) in line.enumerated() {
//            let surround = [(x-1, y-1), (x, y-1), (x+1, y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x, y+1),]
//            surround.filter{$0.0 >= 0 && $0.0 < maxX && $0.1 >= 0 && $0.1 < maxY}
//            if entry == "." {
//                let trees = surround.reduce(0) { (count, pnt) -> Int in
//                    return count + world[pnt.1][pnt.0] == "|" ? 1 : 0
//                }
//            } else if entry == "|" {
//
//            } else if entry == "#" {
//
//            }
//            newWorld[y].append(world[y][x])
//        }
//    }
//    world = newWorld
//
//    print("\nafter \(minute)")
//    for line in world {
//        var entry = ""
//        for char in line {
//            entry += String(char)
//        }
//        print(entry)
//    }
//}

1000000000 - 35714250 * 28
