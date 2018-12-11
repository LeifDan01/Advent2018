import Foundation

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
var board = [[Int]]()

let serialNumber = 7403

for x in 0...300 {
    var row = [Int]()
    for y in 0...300 {
        row.insert(Cell(x: x, y: y, serialNumber: serialNumber).value, at: y)
    }
    board.insert(row, at: x)
}

var maxScoreAt : (Int, (Int, Int), Int) = (Int.min, (0, 0), 0)

for squareSize in 1...300 {
    let end = 301 - squareSize
    print("\(end) at \(Date())")
    print(maxScoreAt)
    for x in 1...end {
        for y in 1...end {
            var score = 0
            for i in 0..<squareSize {
                for j in 0..<squareSize {
                    score += board[x + i][y + j]
                }
            }
            
            if score > maxScoreAt.0 {
                maxScoreAt.0 = score
                maxScoreAt.1 = (x,y)
                maxScoreAt.2 = squareSize
            }
        }
    }
}

print(maxScoreAt)
