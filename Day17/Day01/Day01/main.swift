import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day17/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)


var world = [[String]]()

var clay = [(Int, Int)]()
content.enumerateLines { line, _ in
    let comp = line.components(separatedBy: ", ")
    let first = comp[0].components(separatedBy: "=")
    let second = comp[1].components(separatedBy: "=")
    let range = second[1].components(separatedBy: "..")
    if first[0] == "x" {
        let x = Int(first[1])!
        for y in Int(range[0])!...Int(range[1])! {
            clay.append((x, y))
        }
    } else {
        let y = Int(first[1])!
        for x in Int(range[0])!...Int(range[1])! {
            clay.append((x, y))
        }
    }
}
var (minX, maxX, minY, maxY) = clay.reduce((Int.max,Int.min,Int.max,Int.min)){(min($0.0, $1.0), max($0.1, $1.0), min($0.2, $1.1), max($0.3, $1.1))}
minX -= 1
maxX += 1
minY -= 1
clay = clay.map{($0.0 - minX, $0.1 - minY)}
for (y, _)  in (minY...maxY).enumerated() {
    world.append([])
    for _ in minX...maxX {
        world[y].append(".")
    }
}
print(minY)
print(maxY)
print(minX)
print(maxX)
print(clay)
world[0][500-minX] = "|"
for (x, y) in clay {
    world[y][x] = "#"
}

var waterFound = true
while waterFound {
    waterFound = false
    var prevRow = [String]()
    var restart = false
    var mY = 0
    for y in 0..<world.count {
        if restart {break}
        restart = true
        let row = world[y]
        if y == 0 { prevRow = row; restart = false; continue }
        //if no row below only water from above
        if y == world.count {
            for (x, ele) in row.enumerated() {
                if ele == "." && prevRow[x] == "|" {
                    world[y][x] = "|"
                }
            }
        } else { //otherwise check bounding boxes and floors
            var leftBound: Int?
            var flow = false
            for (x, ele) in row.enumerated() {
                if ele == "." && prevRow[x] == "|" {
                    world[y][x] = "|"
                    waterFound = true
                    restart = false
                }
                if ele == "|" {
                    leftBound = nil
                    restart = false
                }
                if (ele == "#" || ele == "~") {
                    leftBound = leftBound ?? x
                }
                if ele == "." {
                    if let start = leftBound, flow {
                        if prevRow[start-1] == "#" {
                            for nx in start...x {
                                world[y-1][nx] = "|"
                                waterFound = true
                            }
                        } else {
                            for nx in (start-1)...x {
                                world[y-1][nx] = "|"
                                waterFound = true
                            }
                        }
                    }
                    leftBound = nil
                    flow = false
                }
                if prevRow[x] == "#" {
                    if let start = leftBound, flow {
                        if prevRow[start-1] == "#" {
                            for nx in start..<x {
                                world[y-1][nx] = "~"
                                waterFound = true
                            }
                        } else {
                            for nx in (start-1)..<x {
                                world[y-1][nx] = "|"
                                waterFound = true
                            }
                        }
                    }
                    leftBound = nil
                    flow = false
                }
                if leftBound != nil && prevRow[x] == "|" {
                    flow = true
                }
            }
        }
        prevRow = world[y]
        mY = y
    }
    
    print("\n\n\n NEW RUN")
    var count = 0
    for line in world {
        for row in line {
            if row == "~" {
                count += 1
            }
        }
    }
    
    print("\(mY)  : Count was \(count)")
//    for (n, line) in world.enumerated() {
//        var row = ""
//        for char in line {
//            row += char
//        }
//        print("\(n)\t \(row)")
//    }
//    print()
}



