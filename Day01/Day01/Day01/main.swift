import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day01/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

var lines: [Int] = []
content.enumerateLines { line, _ in
    lines.append(Int(line)!)
}
var found = false
var answer = 0
var counts : Set<Int> = []
var count = 0
while (!found){
    for line in lines {
        //        let number = Int(line)
        count = count + line
        if counts.contains(count) && found == false {
            answer = count
            found = true
        } else {
            counts.insert(count)
        }
    }
}
print(answer)
