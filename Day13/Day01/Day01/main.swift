import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day13/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

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
        return "Cart \(id) at (\(x), \(y)) going \(direction)"
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
        let entry = String(line[index])
        switch entry {
        case "<", ">", "v", "^":
            carts.append(Cart(id: id, x: columNumber, y: lineNumber, direction: entry))
        default:
            break
        }
        world[lineNumber].append(entry)
        columNumber += 1
        id += 1
    }
    lineNumber += 1
}
print(carts)
var iter = 0
while carts.count > 1 {
    iter += 1
    var cartsToRemove = [Int]()
    carts.sort{
        if $0.y == $1.y {
            return $0.x < $1.x
        }
        return $0.y < $1.y
    }
    print(carts)
    let cartIDs = carts.map{$0.id}
    for cartID in cartIDs {
//        if cartsToRemove.contains(cartID) { continue }
        let cart = carts.first{cartID == $0.id}!
        cart.move(world: world)
        
        for otherCartID in cartIDs {
            if cartID == otherCartID { continue }
//            if cartsToRemove.contains(otherCartID) { continue }
            let otherCart = carts.first{otherCartID == $0.id}!
            if cart.x == otherCart.x && cart.y == otherCart.y {
                cartsToRemove.append(cartID)
                cartsToRemove.append(otherCartID)
                print("on \(iter) COLLISION AT (\(cart.x),\(cart.y))")
            }
        }
    }
    for removeId in cartsToRemove {
        carts.remove(at: carts.firstIndex{removeId == $0.id}!)
    }
}
print(carts)
//44,81
//43,81
//135, 83
//135, 82
//135, 84
