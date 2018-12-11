import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)


class Cell : CustomStringConvertible {
    let x : Int
    let y : Int
    let serialNumber: Int
    var value : Int
    
    var description: String {
        return "(\(x), \(y)) with \(value)"
    }
    

    
    init(x: Int, y: Int, serialNumber: Int) {
        self.x = x
        self.y = y
        self.serialNumber = serialNumber
        
        let rackId = x + 10
        let powerLevel = rackId * y
        let increase = powerLevel + serialNumber
        let multi = increase * rackId
        let hundered = (multi / 100) % 10
        value = hundered - 5
    }
}
var board = [Cell]()

for x in 1...3 {
//    board[x] = []
    for y in 1...3 {
        board.append(Cell(x: x, y: y, serialNumber: 18))
    }
}
