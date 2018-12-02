import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day02/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

var lines: [String] = []
content.enumerateLines { line, _ in
    lines.append(line)
}
var found = false
var answer = 0
for line in lines {
    //    print("line1: " + line)
    for index in line.characters.indices {
        let next = line.characters.index(after: index)
        let substring1 = line[..<index] + line[next...]
        //        print("Substring1:")
        //        print(substring1)
        for line2 in lines {
            if (line2 != line) {
                //                print("line2: " + line2)
                for index2 in line2.characters.indices {
                    let next2 = line2.characters.index(after: index2)
                    let substring2 = line2[..<index2] + line2[next2...]
                    if (substring1 == substring2) {
                        print ("found it : " + substring2)
                    }
                }
            }
        }
    }
}
