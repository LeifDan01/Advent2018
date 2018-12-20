import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

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
clay = clay.map{($0.0 - minX, $0.1)}
for (y, _)  in (minY...maxY).enumerated() {
    world.append([])
    for _ in minX...maxX {
        world[y].append(".")
    }
}
world[minY][500-minX] = "|"
for (x, y) in clay {
    world[y][x] = "#"
}
print(minY)
print(maxY)
print(minX)
print(maxX)
print(clay)

var waterFound = true
while waterFound {
    waterFound = false
    var prevRow = [String]()
    for (y, row) in world.enumerated() {
        if y == 0 { prevRow = row; continue }
        
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
                }
                if ele == "|" {
                    leftBound = nil
                }
                if (ele == "#" || ele == "~") {
                    leftBound = leftBound ?? x
                }
                if ele == "." {
                    if let start = leftBound, flow {
                        if prevRow[start] == "#" {
                            for nx in start...x { //need to check for dbl wall
                                world[y-1][nx] = "|"
                                waterFound = true
                            }
                        } else {
                            for nx in (start)...x {
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
                if prevRow[x] == "#" {
                    if let start = leftBound, flow {
                        if prevRow[start] == "#" {
                            for nx in start..<x {
                                world[y-1][nx] = "|"
                                waterFound = true
                            }
                        } else {
                            for nx in (start)..<x {
                                world[y-1][nx] = "~"
                                waterFound = true
                            }
                        }
                    }
                    leftBound = nil
                    flow = false
                }
            }
        }
        prevRow = row
    }
    
    
    for (n, line) in world.enumerated() {
        var row = ""
        for char in line {
            row += char
        }
        print("\(n)\t \(row)")
    }
    print()
}


//var notFound = true
//while notFound {
//    for cart in carts {
//        cart.move(world: world)
//
//        for otherCart in carts {
//            if cart.id == otherCart.id { continue }
//            if cart.x == otherCart.x && cart.y == otherCart.y {
//                notFound = false
//                print("COLLISION AT (\(cart.x),\(cart.y))")
//            }
//        }
//    }
//}
