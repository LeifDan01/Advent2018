import UIKit

func stupidGameWith(pieces: Int, playerCount: Int) -> (Int, Int) {
    var board = [Int]()
    var players = [Int](repeating: 0, count: playerCount)
    var position = 0
    var player = 0
    
    func positionAt(steps : Int) -> Int {
        let boardSize = board.count
        let nextPosition = position + steps
        if nextPosition < 0 {
            return nextPosition + boardSize
        } else if nextPosition >= boardSize {
            return nextPosition - boardSize
        } else {
            return nextPosition
        }
    }
    
    board.insert(0, at: position)
    for i in 1...pieces {
//        print(board)
        //check for 23
        if 0 == (i % 23) {
            players[player] += i
            position = positionAt(steps: -7)
            players[player] += board.remove(at: position)
        } else {
            position = positionAt(steps: 2)
            board.insert(i, at: position)
        }
        
        //set next player
        player += 1
        player = player == playerCount ? 0 : player
    }
    
    print(players)
    
    return (0,0)
}

print(stupidGameWith(pieces: 71032, playerCount: 441))
