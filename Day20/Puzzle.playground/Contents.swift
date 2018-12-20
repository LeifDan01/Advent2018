import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
content.dropLast()
content.dropFirst()

class Room : CustomStringConvertible {
    static var iders = 0
    let id: Int
    var x : Int
    var y : Int
    var n : Room?
    var e : Room?
    var s : Room?
    var w : Room?
    
    var description: String {
        let doors = [n == nil, e == nil, s == nil, w == nil]
        return "(\(x), \(y)) with \(doors)"
    }
    
    init(x: Int, y: Int) {
        self.id = Room.iders
        Room.iders += 1
        self.x = x
        self.y = y
    }
}

var rooms = [Room]()
var startRoom = Room(x: 0, y: 0)

func parse(cRoom: Room, path: String) {
    guard let first = path.first  else { return }
    var nextPath = String(path.dropFirst())
    switch first {
    case "(":
        var paths = [String]()
        var deep = 0
        var cPath = ""
        var finalPath = ""
        for char in nextPath {
            if deep < 0 {
                finalPath += String(char)
            } else {
                switch char {
                case "(":
                    deep += 1
                    cPath += String(char)
                case ")":
                    if deep == 0 {
                        for path in paths {
                            parse(cRoom: cRoom, path: path)
                        }
                    } else {
                        deep -= 1
                        cPath += String(char)
                    }
                case "|":
                    if deep == 0 {
                        paths.append(cPath)
                        cPath = ""
                    } else {
                        cPath += String(char)
                    }
                default:
                    cPath += String(char)
                }
            }
        }
        nextPath = finalPath
    case "N":
        let nRoom = rooms.first{$0.x == cRoom.x && $0.y == cRoom.y+1} ?? Room(x: cRoom.x, y: cRoom.y+1)
        cRoom.n = nRoom
        nRoom.s = cRoom
        rooms.append(nRoom)
        parse(cRoom: nRoom, path: nextPath)
    case "E":
        let nRoom = rooms.first{$0.x == cRoom.x+1 && $0.y == cRoom.y} ?? Room(x: cRoom.x+1, y: cRoom.y)
        cRoom.e = nRoom
        nRoom.w = cRoom
        rooms.append(nRoom)
        parse(cRoom: nRoom, path: nextPath)
    case "S":
        let nRoom = rooms.first{$0.x == cRoom.x && $0.y == cRoom.y-1} ?? Room(x: cRoom.x, y: cRoom.y-1)
        cRoom.s = nRoom
        nRoom.n = cRoom
        rooms.append(nRoom)
        parse(cRoom: nRoom, path: nextPath)
    case "W":
        let nRoom = rooms.first{$0.x == cRoom.x-1 && $0.y == cRoom.y} ?? Room(x: cRoom.x-1, y: cRoom.y)
        cRoom.w = nRoom
        nRoom.e = cRoom
        rooms.append(nRoom)
        parse(cRoom: nRoom, path: nextPath)
    default:
        break
    }
}

parse(cRoom: startRoom, path: content)

for room in rooms {
    print(room)
}
