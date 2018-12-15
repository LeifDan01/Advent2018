import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

var recipes = [3, 7]
var elves = [0, 1]
let ignored = 702831
while recipes.count < ignored + 10 {
    //calc score
    var total = 0
    for elf in elves {
        total += recipes[elf]
    }
    //extend recipes
    for char in String(total) {
        recipes.append(Int(String(char))!)
    }
    let size = recipes.count
    //move elves
    for (index, elf) in elves.enumerated() {
        elves[index] = (elf + recipes[elf] + 1) % size
    }
    
//    print(recipes)
//    print(elves)
}

var answer = ""
let end = ignored + 10
for i in ignored..<end {
    answer += String(recipes[i])
}
print(answer)



class Cart : CustomStringConvertible {
    let id: Int
    var x : Int
    var y : Int
    var direction : String
    var turns = 0
    
    var description: String {
        return "(\(x), \(y)) going \(direction)"
    }
    
    init(id: Int, x: Int, y: Int, direction: String) {
        self.id = id
        self.x = x
        self.y = y
        self.direction = direction
    }
}
