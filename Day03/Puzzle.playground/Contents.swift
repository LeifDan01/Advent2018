import UIKit

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
    
    func collidesWith(piece: Piece) -> Bool {
        return true
    }
}

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var lines: [Piece] = []
content.enumerateLines { line, _ in
    lines.append(Piece(line: line))
}
var used = Set<String>()
var duplicate = Set<String>()

for line in lines {
    for x in 1...line.width {
        for y in 1...line.height {
            let location = "\(x+line.originWidth)x\(y+line.originHeight)"
            if used.contains(location) {
                duplicate.insert(location)
            }
            used.insert(location)
        }
    }
}


print(duplicate.count)
