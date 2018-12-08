import UIKit

let fileURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let content = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)

class Node : CustomStringConvertible {
    let id: Int
    var nodeIds : [Int]
    var metas : [Int]
    
    var description: String {
        return "\(id) has \(metas) with nodes: \(nodeIds)"
    }
    
    init(id: Int, nodeIds: [Int], metas: [Int]) {
        self.id = id
        self.nodeIds = nodeIds
        self.metas = metas
    }
    
    func value(nodes: [Node]) -> Int {
        print("get value for \(id)")
        var sum = 0
        if nodeIds.count == 0 {
            sum += metas.reduce(0){$0 + $1}
            print("value for \(id) is \(sum)")
            return sum
        } else {
            for meta in metas {
                if meta > 0 && meta <= nodeIds.count {
                    let nodeNumber = nodeIds[meta - 1]
                    let node = nodes.first{$0.id == nodeNumber}
                    sum += node!.value(nodes: nodes)
                }
            }
            return sum
        }
    }
}


let items = content.components(separatedBy: " ")
print(items.count)
var values = [Int](repeating: 0, count: items.count)
var theIndex = 0
for item in items {
    if let value = Int(item) {
        values[theIndex] = value
    }
    theIndex += 1
}
print(values)

var id = 0
func createNode() -> [Node] {
    var nodes : [Node] = []
    var myNodes : [Int] = []
    var metas : [Int] = []
    let myid = id
    id += 1
    let nodeCount = values.remove(at: 0)
    let metaCount = values.remove(at: 0)
    
    if nodeCount > 0 {
        for _ in 0..<nodeCount {
            let newNodes = createNode()
            myNodes.append(newNodes.last!.id)
            nodes.append(contentsOf: newNodes)
        }
    }

    if metaCount > 0 {
        for _ in 0..<metaCount {
            metas.append(values.remove(at: 0))
        }
    }
    
    let node = Node(id: myid, nodeIds: myNodes, metas: metas)
    print(node)
    nodes.append(node)
    
    return nodes
}

var nodes = createNode()
//var sum = 0
//while (nodes.count > 0) {
//    let node = nodes.remove(at: nodes.count-1)
//    for meta in node.metas {
//        sum += meta
//    }
////    print(nodes.remove(at: nodes.count-1))
//}
//print(sum)

print (nodes[nodes.count-1].value(nodes: nodes))
