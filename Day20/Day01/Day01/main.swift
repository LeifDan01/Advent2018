import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day20/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
var content = try String(contentsOf: url, encoding: String.Encoding.utf8)

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
        let doors = [n != nil, e != nil, s != nil, w != nil]
        return "(\(x), \(y)) with \(doors)"
    }
    
    init(x: Int, y: Int) {
        self.id = Room.iders
        Room.iders += 1
        self.x = x
        self.y = y
    }
}

var startRoom = Room(x: 0, y: 0)
var rooms = [startRoom]

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
                        paths.append(cPath)
                    } else {
                        cPath += String(char)
                    }
                    deep -= 1
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
        for path in paths {
            parse(cRoom: cRoom, path: path + finalPath)
        }
        nextPath = finalPath
    case "N":
        if let nRoom = rooms.first(where: {$0.x == cRoom.x && $0.y == cRoom.y+1}) {
            cRoom.n = nRoom
            nRoom.s = cRoom
            parse(cRoom: nRoom, path: nextPath)
        } else {
            let nRoom = Room(x: cRoom.x, y: cRoom.y+1)
            cRoom.n = nRoom
            nRoom.s = cRoom
            rooms.append(nRoom)
            parse(cRoom: nRoom, path: nextPath)
        }
    case "E":
        if let nRoom = rooms.first(where: {$0.x == cRoom.x+1 && $0.y == cRoom.y})  {
            cRoom.e = nRoom
            nRoom.w = cRoom
            parse(cRoom: nRoom, path: nextPath)
        } else {
            let nRoom = Room(x: cRoom.x+1, y: cRoom.y)
            cRoom.e = nRoom
            nRoom.w = cRoom
            rooms.append(nRoom)
            parse(cRoom: nRoom, path: nextPath)
        }
    case "S":
        if let nRoom = rooms.first(where: {$0.x == cRoom.x && $0.y == cRoom.y-1})  {
            cRoom.s = nRoom
            nRoom.n = cRoom
            parse(cRoom: nRoom, path: nextPath)
        } else {
            let nRoom = Room(x: cRoom.x, y: cRoom.y-1)
            cRoom.s = nRoom
            nRoom.n = cRoom
            rooms.append(nRoom)
            parse(cRoom: nRoom, path: nextPath)
        }
    case "W":
        if let nRoom = rooms.first(where: {$0.x == cRoom.x-1 && $0.y == cRoom.y})  {
            cRoom.w = nRoom
            nRoom.e = cRoom
            parse(cRoom: nRoom, path: nextPath)
        } else {
            let nRoom = Room(x: cRoom.x-1, y: cRoom.y)
            cRoom.w = nRoom
            nRoom.e = cRoom
            rooms.append(nRoom)
            parse(cRoom: nRoom, path: nextPath)
        }
    default:
        break
    }
}


parse(cRoom: startRoom, path: String(content.dropFirst().dropLast()))
rooms.sort { (first, second) -> Bool in
    if first.y == second.y {
        return first.x < second.x
    }
    return first.y > second.y
}
for room in rooms {
    print(room)
}
