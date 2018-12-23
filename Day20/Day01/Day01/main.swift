import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day20/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

class Room : CustomStringConvertible {
    var x : Int
    var y : Int
    var distance = Int.max
    var n : Room?
    var e : Room?
    var s : Room?
    var w : Room?
    
    var description: String {
        let doors = [n != nil, e != nil, s != nil, w != nil]
        return "(\(x), \(y)) with \(doors) at distance \(distance)"
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

var startRoom = Room(x: 0, y: 0)
var rooms : [String : Room] = ["0 0" : startRoom]
func parse(sRoom: Room, from: String.Index, finish: String.Index? = nil) {
    var nextSwitch: String.Index?
    var cRoom = sRoom
    for index in content.indices[from..<content.endIndex] {
        if nextSwitch != nil { break }
        switch content[index] {
        case "(":
            nextSwitch = index
            break;
        case "N":
            if let nRoom = cRoom.n {
                cRoom = nRoom
            } else if let nRoom = rooms["\(cRoom.x) \(cRoom.y+1)"]  { // rooms.first(where: {$0.x == cRoom.x && $0.y == cRoom.y+1}) {
                cRoom.n = nRoom
                nRoom.s = cRoom
                cRoom = nRoom
                print("newDoor")
            } else {
                let nRoom = Room(x: cRoom.x, y: cRoom.y+1)
                cRoom.n = nRoom
                nRoom.s = cRoom
                rooms["\(cRoom.x) \(cRoom.y+1)"] = nRoom
                cRoom = nRoom
                print("newRoom \(nRoom)")
            }
        case "E":
            if let nRoom = cRoom.e {
                cRoom = nRoom
            } else if let nRoom = rooms["\(cRoom.x+1) \(cRoom.y)"]  { // rooms.first(where: {$0.x == cRoom.x+1 && $0.y == cRoom.y})  {
                cRoom.e = nRoom
                nRoom.w = cRoom
                cRoom = nRoom
                print("newDoor")
            } else {
                let nRoom = Room(x: cRoom.x+1, y: cRoom.y)
                cRoom.e = nRoom
                nRoom.w = cRoom
                rooms["\(cRoom.x+1) \(cRoom.y)"] = nRoom
                cRoom = nRoom
                print("newRoom \(nRoom)")
            }
        case "S":
            if let nRoom = cRoom.s {
                cRoom = nRoom
            } else if let nRoom = rooms["\(cRoom.x) \(cRoom.y-1)"]  { // rooms.first(where: {$0.x == cRoom.x && $0.y == cRoom.y-1})  {
                cRoom.s = nRoom
                nRoom.n = cRoom
                cRoom = nRoom
                print("newDoor")
            } else {
                let nRoom = Room(x: cRoom.x, y: cRoom.y-1)
                cRoom.s = nRoom
                nRoom.n = cRoom
                rooms["\(cRoom.x) \(cRoom.y-1)"] = nRoom
                cRoom = nRoom
                print("newRoom \(nRoom)")
            }
        case "W":
            if let nRoom = cRoom.w {
                cRoom = nRoom
            } else if let nRoom = rooms["\(cRoom.x-1) \(cRoom.y)"]  { // rooms.first(where: {$0.x == cRoom.x-1 && $0.y == cRoom.y})  {
                cRoom.w = nRoom
                nRoom.e = cRoom
                cRoom = nRoom
                print("newDoor")
            } else {
                let nRoom = Room(x: cRoom.x-1, y: cRoom.y)
                cRoom.w = nRoom
                nRoom.e = cRoom
                rooms["\(cRoom.x-1) \(cRoom.y)"] = nRoom
                cRoom = nRoom
                print("newRoom \(nRoom)")
            }
        case ")":
            fallthrough
        case "|":
            if let finish = finish {
                parse(sRoom: cRoom, from: finish)
            }
            return
        default:
            break
        }
    }
    if let nextSwitch = nextSwitch {
        var paths = [String.Index]()
        var deep = -1
        for index in content.indices[nextSwitch..<content.endIndex] {
            switch content[index] {
            case "(":
                deep += 1
                if deep == 0 {
                    paths.append(content.index(index, offsetBy: 1))
                }
            case ")":
                if deep == 0 {
                    for path in paths {
                        parse(sRoom: cRoom, from: path, finish: content.index(index, offsetBy: 1))
                    }
                    return
                }
                deep -= 1
            case "|":
                if deep == 0 {
                    paths.append(content.index(index, offsetBy: 1))
                }
            default:
                break
            }
        }
    }
}

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

parse(sRoom: startRoom, from: content.index(content.startIndex, offsetBy: 1))
print("Found \(rooms.count) rooms")

startRoom.distance = 0
findDistances(cRoom: startRoom)
var result = rooms.sorted { (arg1, arg2) -> Bool in
    arg1.value.distance > arg2.value.distance
}
print(result.first!.value)


result = rooms.sorted { (first, second) -> Bool in
    if first.value.y == second.value.y {
        return first.value.x < second.value.x
    }
    return first.value.y > second.value.y
}
var top = ""
var sides = ""
var bottom = ""
var y = rooms.first!.value.y
for room in result {
    if y != room.value.y {
        print(top)
        print(sides)
        print(bottom)
        top = ""
        sides = ""
        bottom = ""
        y = room.value.y
    }
    
    top += "#" + (room.value.n == nil ? "#" : "-") + "#"
    sides += (room.value.w == nil ? "#" : "|") + "." + (room.value.e == nil ? "#" : "|")
    bottom += "#" + (room.value.s == nil ? "#" : "-") + "#"
}
print(top)
print(sides)
print(bottom)
