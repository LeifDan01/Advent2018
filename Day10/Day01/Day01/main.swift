import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day10/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

class Star : CustomStringConvertible {
    var horizontal : Int
    var vertical : Int
    var momentumH : Int
    var momentumV : Int
    
    var description: String {
        return "(\(horizontal), \(vertical)) going (\(momentumH), \(momentumV))"
    }
    
    func positionAt(time: Int) -> (Int, Int) {
        let x = horizontal + time * momentumH
        let y = vertical + time * momentumV
        return (x, y)
    }
    
    init(line: String) {
        let items = line.components(separatedBy: "=<")
        let positionString = items[1].components(separatedBy: ", ")
        self.horizontal = Int(positionString[0].trimmingCharacters(in: .whitespaces))!
        let verticalString = positionString[1].components(separatedBy: ">")[0]
        self.vertical = Int(verticalString.trimmingCharacters(in: .whitespaces))!
        
        let momentumString = items[2].components(separatedBy: ", ")
        self.momentumH = Int(momentumString[0].trimmingCharacters(in: .whitespaces))!
        let momentumVString = momentumString[1].components(separatedBy: ">")[0]
        self.momentumV = Int(momentumVString.trimmingCharacters(in: .whitespaces))!
        //        print(self)
    }
}

var stars: [Star] = []
content.enumerateLines { line, _ in
    stars.append(Star(line: line))
}


func myPrint(stars: [Star]) {
    
    for time in 10450...10470 {
        var starsNow = [Int: [Int]]()
        var hmin = Int.max
        var hmax = Int.min
        var vmin = Int.max
        var vmax = Int.min
        
        for star in stars {
            let (x, y) = star.positionAt(time: time)
            starsNow[x] = starsNow[x] ?? []
            starsNow[x]!.append(y)
        }
        
        for (key, values) in starsNow {
            hmin = min(hmin, key)
            hmax = max(hmax, key)
            for y in values {
                vmin = min(vmin, y)
                vmax = max(vmax, y)
            }
        }
        
        print("\(time) has x \(hmax-hmin) and y \(vmax-vmin)")
        
        for y in vmin...vmax {
            var lineString = ""
            for x in hmin...hmax {
                var isContained = false
                isContained = starsNow[x]?.contains(y) ?? false
                lineString += isContained ? "#" : "."
            }
            print(lineString)
        }
    }
}

myPrint(stars: stars)

