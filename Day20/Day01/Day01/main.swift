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
    var distance = Int.max
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
var splitCount = 0
func parse(cRoom: Room, path: String) {
    if path == "" { return }
    guard let first = path.first  else { return }
    let nextPath = String(path.dropFirst())
    switch first {
    case "(":
        splitCount += 1
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
        print("Split \(splitCount) with \(finalPath.count) character after")
        for path in paths {
            parse(cRoom: cRoom, path: "\(path)\(finalPath)")
        }
        return
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
print("Found \(rooms.count) rooms")
func findDistances(cRoom: Room, steps: Int = 1) {
    var rooms = [Room]()
    for r in [cRoom.n, cRoom.e, cRoom.s, cRoom.w] {
        if let r = r, r.distance > steps {
            r.distance = steps
            rooms.append(r)
        }
    }
    for r in rooms {
        findDistances(cRoom: r, steps: steps + 1)
    }
}

parse(cRoom: startRoom, path: String(content.dropFirst().dropLast()))
startRoom.distance = 0
findDistances(cRoom: startRoom)

rooms.sort { (first, second) -> Bool in
    first.distance > second.distance
}

print(rooms.first!)

//rooms.sort { (first, second) -> Bool in
//    if first.y == second.y {
//        return first.x < second.x
//    }
//    return first.y > second.y
//}
//var top = ""
//var sides = ""
//var bottom = ""
//var y = rooms.first!.y
//for room in rooms {
//    if y != room.y {
//        print(top)
//        print(sides)
//        print(bottom)
//        top = ""
//        sides = ""
//        bottom = ""
//        y = room.y
//    }
//
//    top += "#" + (room.n == nil ? "#" : "-") + "#"
//    sides += (room.w == nil ? "#" : "|") + "." + (room.e == nil ? "#" : "|")
//    bottom += "#" + (room.s == nil ? "#" : "-") + "#"
//}
//print(top)
//print(sides)
//print(bottom)
