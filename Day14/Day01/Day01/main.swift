import Foundation

var recipes = [3, 7]
var elves = [0, 1]
let ignored = 702831
var lastones = "000000"
var notFound = true
while notFound {
    //calc score
    var total = 0
    for elf in elves {
        total += recipes[elf]
    }
    //extend recipes
    for char in String(total) {
        recipes.append(Int(String(char))!)
        lastones += String(char)
        lastones.remove(at: lastones.startIndex)
//        print(lastones)
        if String(ignored) == lastones {
            print(total)
            notFound = false
        }
    }
    let size = recipes.count
    //move elves
    for (index, elf) in elves.enumerated() {
        elves[index] = (elf + recipes[elf] + 1) % size
    }
    
}

//var answer = ""
//let end = ignored + 10
//for i in ignored..<end {
//    answer += String(recipes[i])
//}
//20340233
print(recipes.count - lastones.characters.count)
