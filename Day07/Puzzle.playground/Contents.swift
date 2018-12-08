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
    var workToDo: Int
    var preReq : [String] = []
    
    var description: String {
        return "\(item) requires \(preReq) for \(workToDo)"
        //        return "\n(\(x), \(y)) Value: \(size())"
        //        return "(\(x), \(y)) T: \(top) B: \(bottom) L: \(left) R: \(right)\n"
    }
    
    init(_ me: String) {
        item = me
        workToDo = Int(me.characters.first!.unicodeScalars.first!.value) - 4
    }
    
    init(_ me: String, req: String) {
        item = me
        preReq.append(req)
        workToDo = Int(me.characters.first!.unicodeScalars.first!.value) - 4
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

var done : [String] = []
var inWork : [Step] = []

var workers = 5
var count = 0

while true {
    count += 1
    print("Steps: \(steps)")
    
    // find things to work on
    var options : [Step] = []
    for step in steps {
        if done.contains(step.item){
            continue
        }
        var inInWork = false
        for work in inWork {
            if work.item == step.item {
                inInWork = true
            }
        }
        if inInWork {continue}
        
        var passed = true
        for req in step.preReq {
            if !(done.contains(req)) {
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
    
    //put tihng to work
    while options.count > 0 && inWork.count < workers {
        inWork.append(options.remove(at: 0))
    }
    
    print("InWork: \(inWork)")
    //work
    for step in inWork {
        step.workToDo -= 1
    }
    
    //clear out the debris
    var found = true
    while found {
        found = false
        for (index, step) in inWork.enumerated() {
            if step.workToDo == 0 {
                found = true
                done.append(step.item)
                inWork.remove(at: index)
                break
            }
        }
    }
    
    if done.count == steps.count {
        break
    }
}

print(done)
print(count)
