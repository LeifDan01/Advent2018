import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var stars: [Star] = []
content.enumerateLines { line, _ in
    stars.append(Star(line: line))
}

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

func myPrint(stars: [Star]) {
    var starsNow = [(Int, Int)]
    var hmin = Int.max
    var hmax = Int.min
    var vmin = Int.max
    var vmax = Int.min
    var time = 0
        
    for star in stars {
        let (x, y)  = star.positionAt(time: i)
        hmin = min(hmin, x)
        hmax = max(hmax, x)
        vmin = min(vmin, y)
        vmax = max(vmax, y)
    }
    
    for y in vmin...vmax {
        var lineString = ""
        for x in hmin...hmax {
            var isContained = false
            isContained = stars.contains{(x, y) == $0.positionAt(time: time)}
            lineString += isContained ? "#" : "."
        }
        print(lineString)
    }
}

//myPrint(stars: stars)
