import UIKit

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

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
