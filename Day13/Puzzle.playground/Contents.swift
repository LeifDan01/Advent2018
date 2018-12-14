import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

let turns = [">", "v", "<", "^"]
func turn(current: String, number: Int) -> String {
    var index = turns.firstIndex(of: current)!
    switch number {
    case 1:
        index += 3
    case 3:
        index += 1
    default:
        break
    }
    index = index < 4 ? index : index - 4
    return turns[index]
}

var world = [[String]]()
class Cart : CustomStringConvertible {
    let id: Int
    var x : Int
    var y : Int
    var direction : String
    var turns = 0
    
    var description: String {
        return "(\(x), \(y)) going \(direction)"
    }
    
    func move(world: [[String]]) {
        switch direction {
        case "<":
            x = x - 1
        case ">":
            x = x + 1
        case "^":
            y = y - 1
        case "v":
            y = y + 1
        default:
            break
        }
        let position = world[y][x]
        if "+" == position {
            turns += 1
            direction = turn(current: direction, number: turns)
            turns = turns < 3 ? turns : 0
        } else {
            switch (position, direction) {
            case ("/", "<"):
                direction = "v"
            case ("/", ">"):
                direction = "^"
            case ("/", "^"):
                direction = ">"
            case ("/", "v"):
                direction = "<"
            case ("\\", "<"):
                direction = "^"
            case ("\\", ">"):
                direction = "v"
            case ("\\", "^"):
                direction = "<"
            case ("\\", "v"):
                direction = ">"
            default:
                break
            }
        }
    }
    
    init(id: Int, x: Int, y: Int, direction: String) {
        self.id = id
        self.x = x
        self.y = y
        self.direction = direction
    }
}

var carts = [Cart]()
var lineNumber = 0
var id = 0
content.enumerateLines { line, _ in
    world.append([])
    var columNumber = 0
    for index in line.characters.indices {
        var entry = String(line[index])
        switch entry {
        case "<":
            carts.append(Cart(id: id, x: columNumber, y: lineNumber, direction: entry))
            entry = "-"
        case ">":
            carts.append(Cart(id: id, x: columNumber, y: lineNumber, direction: entry))
            entry = "-"
        case "^":
            carts.append(Cart(id: id, x: columNumber, y: lineNumber, direction: entry))
            entry = "|"
        case "v":
            carts.append(Cart(id: id, x: columNumber, y: lineNumber, direction: entry))
            entry = "|"
        default:
            break
        }
        world[lineNumber].append(entry)
        columNumber += 1
        id += 1
    }
    lineNumber += 1
}
var notFound = true
while notFound {
    for cart in carts {
        cart.move(world: world)
        
        for otherCart in carts {
            if cart.id == otherCart.id { continue }
            if cart.x == otherCart.x && cart.y == otherCart.y {
                notFound = false
                print("COLLISION AT (\(cart.x),\(cart.y))")
            }
        }
    }
}
