import UIKit

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var lines: [String] = []
content.enumerateLines { line, _ in
    lines.append(line)
}
var found = false
var answer = 0
var count = 0
var threes = 0
var twos = 0
for line in lines {
    var counts : [Character: Int] = [:]
    for index in line.characters.indices {
        counts[line[index]] = (counts[line[index]] ?? 0) + 1
    }
    var found2 = 0
    var found3 = 0
    for (key, value) in counts {
        if value == 2 {
            found2 = 1
        }
        if value == 3 {
            found3 = 1
        }
    }
    twos += found2
    threes += found3
}
print(twos * threes)
