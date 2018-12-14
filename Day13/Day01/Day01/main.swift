import Foundation

let currentDirectoryURL = URL(fileURLWithPath: "///Users/leif/Desktop/AdventOfCode/Day12/")
let url = URL(fileURLWithPath: "input.txt", relativeTo: currentDirectoryURL)
//let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: url, encoding: String.Encoding.utf8)

func getPatternFrom(line: String) -> [Int] {
    var position = [Int]()
    for index in line.characters.indices {
        position.append(line[index] == "." ? 0 : 1)
    }
    return position
}

//var patterns = [[[[[Bool]]]]]()
var simple = [false, false]
var next = [simple, simple]
var again = [next, next]
var almost = [again, again]
var patterns = [almost, almost]

content.enumerateLines { line, _ in
    let parts = line.components(separatedBy: " => ")
    let position = getPatternFrom(line: parts[0])
    
    print("\(position) \(parts[1] == "#")")
    patterns[position[0]][position[1]][position[2]][position[3]][position[4]] = parts[1] == "#"
}
print(patterns)
let start = "#........#.#.#...###..###..###.#..#....###.###.#.#...####..##..##.#####..##...#.#.....#...###.#.####"
//let start = "#..#.#..##......###...###"
let expGen1="....###......##..."
let generations = 1000000

var position = 0
var pots = start

func check(pattern: String) -> Bool {
    let position = getPatternFrom(line: pattern)
    return patterns[position[0]][position[1]][position[2]][position[3]][position[4]]
}
print(position)
print("0 : \(pots)")
for year in 1...generations {
    
    while(true) {
        let start = pots.characters.startIndex
        let end = pots.characters.index(start, offsetBy: 5)
        if pots[start..<end] == "....." {
            pots = String(pots[end..<pots.characters.endIndex])
            position += 5
        } else {
            break
        }
    }
    
    //make sure we have space on sides
    position = position - 1
    var thisYear = "..." + pots + "..."
    var nextYear = ""
    
    
    for index in thisYear.characters.indices {
        let endIndex = thisYear.characters.index(index, offsetBy: 5)
        let line = String(thisYear[index..<endIndex])
        let result = check(pattern: line)
        nextYear = nextYear + (result ? "#" : ".")
        //        print ("\(line) was \(result)")
        
        if endIndex == thisYear.characters.endIndex {
            break
        }
    }
    print("\(year) : \(nextYear)")
    pots = nextYear
    
    var count = 0
    var cntPosition = position
    for index in pots.characters.indices {
        if pots[index] == "#" {
            count += cntPosition
        }
        cntPosition += 1
    }
    print(count)
}

//73151  5852946
//73152  5853026 -80
//73153  5853106 -80
//73154  5853186 -80
//5853186
