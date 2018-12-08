import UIKit

let fileURL = Bundle.main.url(forResource: "input", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

class Piece : CustomStringConvertible {
    var first : String
    var second : String
    
    var description: String {
        return "\(first) before \(second)"
        //        return "\n(\(x), \(y)) Value: \(size())"
//        return "(\(x), \(y)) T: \(top) B: \(bottom) L: \(left) R: \(right)\n"
    }
    
    init(line: String) {
        let items = line.components(separatedBy: " ")
        self.first = items[1]
        self.second = items[7]
    }
}

class Step : CustomStringConvertible  {
    var item : String
    var preReq : [String] = []
    
    var description: String {
        return "\(item) requires \(preReq)"
        //        return "\n(\(x), \(y)) Value: \(size())"
        //        return "(\(x), \(y)) T: \(top) B: \(bottom) L: \(left) R: \(right)\n"
    }
    
    init(_ me: String) {
        item = me
    }
    
    init(_ me: String, req: String) {
        item = me
        preReq.append(req)
    }
}

var lines: [Piece] = []
content.enumerateLines { line, _ in
    lines.append(Piece(line: line))
}

var steps: [Step] = []
for line in lines{
    var foundFirst = false
    var foundSecond = false
    
    for step in steps {
        if line.first == step.item {
            foundFirst = true
        }
        if line.second == step.item {
            foundSecond = true
            step.preReq.append(line.first)
        }
    }
    
    if !foundFirst {
        steps.append(Step(line.first))
    }
    if !foundSecond {
        steps.append(Step(line.second, req: line.first))
    }
}

var answer : [String] = []

for i in 0..<steps.count {
    var options : [Step] = []
    for step in steps {
        if answer.contains(step.item){
            continue
        }
        var passed = true
        for req in step.preReq {
            if !(answer.contains(req)) {
                passed = false
            }
        }
        if passed {
            options.append(step)
        }
    }
    options.sort { (first, second) -> Bool in
        first.item < second.item
    }
    answer.append(options[0].item)
}

print(steps)
print(answer)
