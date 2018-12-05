import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day05/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)


var options = [String: Int]()
for nchar in 97...122 {
    let char = String(UnicodeScalar(nchar)!)
    
    var line = content
    line = line.replacingOccurrences(of: char, with: "")
    line = line.replacingOccurrences(of: char.uppercased(), with: "")
    //remove char
    
    var found = true
    while found
    {
        found = false
        for index in line.characters.indices {
            if found || index == line.characters.endIndex {break}
            let char1 = String(line[index])
            let nextI = line.characters.index(after: index)
            if nextI == line.characters.endIndex {break}
            let char2 = String(line[nextI])
            if (char1.uppercased() != char1 && char1.uppercased() == char2) ||
                (char2.uppercased() != char2 && char2.uppercased() == char1) {
                let nnI = line.characters.index(after: nextI)
                line = String(line[..<index] + line[nnI...])
                //            print(line)
                found = true
            }
        }
        
        if !found {
            options[char] = line.count
            print("\(char) got \(line.count)")
        }
    }
}
print(options)
