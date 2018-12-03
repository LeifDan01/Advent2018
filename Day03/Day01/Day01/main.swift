import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day03/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

struct Piece {
    let id: String
    var originWidth : Int
    var originHeight : Int
    var width: Int
    var height: Int
    
    init(line: String) {
        let items = line.components(separatedBy: " ")
        id = items[0]
        let origin = items[2].components(separatedBy: ",")
        originWidth = Int(origin[0])!
        originHeight = Int(origin[1].dropLast())!
        let dimensions = items[3].components(separatedBy: "x")
        width = Int(dimensions[0])!
        height = Int(dimensions[1])!
    }
    
    func contains(x: Int, y: Int) -> Bool {
        var inX = false
        var inY = false
        inX = x >= originWidth && x <= originWidth + width
        inY = y >= originHeight && y <= originHeight + height
        return inX && inY
    }
    
    func collidesWith(piece: Piece) -> Bool {
        //        print("\(self)  \(piece)")
        for x in 1...width {
            for y in 1...height {
                //                print("\(x + originWidth) \(y + originHeight)")
                if piece.contains(x: x + originWidth, y: y + originHeight) {
                    return true
                }
            }
        }
        return false
    }
}

var lines: [Piece] = []
content.enumerateLines { line, _ in
    lines.append(Piece(line: line))
}
var used = Set<String>()

for line1 in lines {
    var collision = false
    for line2 in lines {
        if line1.id != line2.id {
            if line1.collidesWith(piece: line2) {
                collision = true
                break
            }
        }
    }
    if collision == false {
        print("found the ONE: \(line1)")
    }
}
