import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

class Piece : CustomStringConvertible {
    let id: Int
    var x : Int
    var y : Int
    var top: (Int, Int)?
    var bottom: (Int, Int)?
    var right: (Int, Int)?
    var left: (Int, Int)?
    
    var description: String {
        //        return "\n(\(x), \(y)) Value: \(size())"
        return "(\(x), \(y)) T: \(top) B: \(bottom) L: \(left) R: \(right)\n"
    }
    
    func coords() -> (Int, Int) {
        return (x, y)
    }
    
    init(id: Int, line: String) {
        let items = line.components(separatedBy: ", ")
        self.id = id
        self.x = Int(items[0])!
        self.y = Int(items[1])!
    }
    
    func distanceBetween(first: (Int, Int), second: (Int, Int)) -> Int {
        return abs(first.0 - second.0) + abs(first.1 - second.1)
    }
    
    func isClosestTo(_ point: (Int, Int)) -> Bool {
        let distance = distanceBetween(first: self.coords(), second: point)
        if distance >= distanceBetween(first: top!, second: point) { return false}
        if distance >= distanceBetween(first: bottom!, second: point) { return false}
        if distance >= distanceBetween(first: left!, second: point) { return false}
        if distance >= distanceBetween(first: right!, second: point) { return false}
        return true
    }
    
    func size() -> Int? {
        if let top = top, let bottom = bottom, let right = right, let left = left {
            var count = 0
            for h in top.1...bottom.1 {
                var row = ""
                for w in left.0...right.0 {
                    if isClosestTo((w, h)) {
                        count += 1
                        if w == x && h == y {
                            row += "X"
                        } else {
                            row += "x"
                        }
                    } else {
                        if w == top.0 && h == top.1 {
                            row += "T"
                        } else if w == bottom.0 && h == bottom.1 {
                            row += "B"
                        } else if w == left.0 && h == left.1 {
                            row += "L"
                        } else if w == right.0 && h == right.1 {
                            row += "R"
                        } else {
                            row += "."
                        }
                    }
                }
                print(row)
            }
            print("\(x), \(y)")
            print("height: \(1+bottom.1-top.1)  width: \(1+right.0-left.0)")
            print(count)
            print()
            return count
        }
        return nil
    }
    
    func setBorders(_ other: Piece) {
        let vDis = self.y - other.y
        let hDis = self.x - other.x
        
        //top bottom
        if vDis != 0 {
            if abs(vDis) >= abs(hDis) {
                let value = abs(vDis)
                let current = (vDis > 0 ? top : bottom) ?? other.coords()
                let currentV = abs(self.y - current.1)
                if value <= currentV {
                    if vDis > 0 {
                        self.top = other.coords()
                    } else {
                        self.bottom = other.coords()
                    }
                }
            }
        }
        
        //left right {
        if hDis != 0 {
            if abs(hDis) >= abs(vDis) {
                let value = abs(hDis)
                let current = (hDis > 0 ? left : right) ?? other.coords()
                let currentH = abs(self.x - current.0)
                if value <= currentH {
                    if hDis > 0 {
                        self.left = other.coords()
                    } else {
                        self.right = other.coords()
                    }
                }
            }
        }
    }
}

var id = 0
var lines: [Piece] = []
content.enumerateLines { line, _ in
    id += 1
    lines.append(Piece(id: id, line: line))
}

//find borders
for line in lines {
    for other in lines {
        if line.id != other.id {
            line.setBorders(other)
        }
    }
}

for line in lines {
    line.size()
}
//print(lines)
