import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

struct Entry {
    var time : Date
    var guardId : Int?
    var isSleep: Bool = false
    var isWake: Bool = false
    
    init(line: String) {
        let items = line.components(separatedBy: " ")
        let date = items[0].dropFirst()
        let time = items[1].dropLast()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'"
        self.time = dateFormatter.date(from: date + " " + time)!
        if items[2] == "Guard" {
            guardId = Int(items[3].dropFirst())!
        }
        
        isSleep = items[2] == "falls"
        isWake = items[2] == "wakes"
    }
}

var lines: [String] = []
content.enumerateLines { line, _ in
    lines.append(line)
}
var line = content
print(line)
var found = true
while found
{
    found = false
    
    for index in line.characters.indices {
        if found { break }
        let char1 = String(line[index])
        let nextI = line.characters.index(after: index)
        let char2 = String(line[nextI])
        if (char1.uppercased() != char1 && char1.uppercased() == char2) ||
            (char2.uppercased() != char2 && char2.uppercased() == char1) {
            let nnI = line.characters.index(after: nextI)
            line = String(line[..<index] + line[nnI...])
            found = true
        }
    }
    if (!found) {
        print(line)
    }
}
//
//var guards = [Int: Double]()
//var currentGuard = 0
//var sleep = Date()
//for entry in lines {
//    if let guardId = entry.guardId {
//        currentGuard = guardId
//    } else if entry.isSleep {
//        sleep = entry.time
//    } else if entry.isWake {
//        var minutes = entry.time.timeIntervalSince(sleep) / 60.0
//        minutes += guards[currentGuard] ?? 0
//        guards[currentGuard] = minutes
//    }
//}
//
//let sleeper = guards.sorted { (arg1, arg2) -> Bool in
//    arg1.value > arg2.value
//    }.first!
//
////print(sleeper)
//var theGuard = 0
//var theMinute = (0, 0.0)
//for myGuard in guards {
//    var minutes = [Int : Double]()
//    print(myGuard.key)
//    for entry in lines {
//        if let guardId = entry.guardId {
//            currentGuard = guardId
//        }
//        if currentGuard == myGuard.key {
//            if entry.isSleep {
//                sleep = entry.time
//            } else if entry.isWake {
//                let calendar = Calendar.current
//                let start = calendar.dateComponents([.hour,.minute,.second], from: sleep).minute!
//                let end = calendar.dateComponents([.hour,.minute,.second], from: entry.time).minute!
//                for i in start..<end {
//                    minutes[i] = (minutes[i] ?? 0) + 1
//                }
//            }
//        }
//    }
//    let hisMinute = minutes.sorted(by: { (arg1, arg2) -> Bool in
//        arg1.value > arg2.value
//    }).first!
//    print(hisMinute)
//    if hisMinute.value > theMinute.1 {
//        theGuard = myGuard.key
//        theMinute = (hisMinute.key, hisMinute.value)
//    }
//}
//print(theGuard)
//print(theMinute)
//
////print(minutes.sorted(by: { (arg1, arg2) -> Bool in
////    arg1.value > arg2.value
////}).first!)
