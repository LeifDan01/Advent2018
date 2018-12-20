import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day18/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

var world = [[String]]()
var lineNum = 0
content.enumerateLines { line, _ in
    world.append([])
    for char in line {
        world[lineNum].append(String(char))
    }
    lineNum += 1
}
var newWorld = [[String]]()
let maxX = world[0].count
let maxY = world.count
for minute in 1...1000000000 {
    newWorld = [[String]]()
    for (y, line) in world.enumerated() {
        newWorld.append([])
        for (x, entry) in line.enumerated() {
            var after = entry
            var surround = [(x-1, y-1), (x, y-1), (x+1, y-1), (x-1, y), (x+1, y), (x-1, y+1), (x, y+1), (x+1, y+1)]
            surround = surround.filter{$0.0 >= 0 && $0.0 < maxX && $0.1 >= 0 && $0.1 < maxY}
            
            let (trees, mills) = surround.reduce((0, 0)) { (count, point) -> (Int, Int) in
                let tree = world[point.1][point.0] == "|" ? 1 : 0
                let mill = world[point.1][point.0] == "#" ? 1 : 0
                return (count.0 + tree, count.1 + mill)
            }
//            print("(\(x), \(y)) has \(trees) trees and \(mills) mills")
            if entry == "." {
                if trees >= 3 { after = "|" }
            } else if entry == "|" {
                if mills >= 3 { after = "#" }
            } else if entry == "#" {
                if mills >= 1 && trees >= 1 { after = "#" }
                else { after = "."}
            }
            newWorld[y].append(after)
        }
    }
    world = newWorld
    
    var ttrees = 0
    var tmills = 0
    for line in world {
        for entry in line {
            if entry == "|" { ttrees += 1 }
            if entry == "#" { tmills += 1 }
        }
    }
    print("\nafter \(minute) there are \(ttrees) trees and \(tmills) mills")
    for line in world {
        var entry = ""
        for char in line {
            entry += String(char)
        }
        print(entry)
    }
}
