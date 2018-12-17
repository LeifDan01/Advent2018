//
//  Thing.swift
//  Day01
//
//  Created by THEMEN DANIELSON on 12/16/18.
//  Copyright © 2018 THEMEN DANIELSON. All rights reserved.
//

import Foundation

class Thing : CustomStringConvertible {
    let id: Int
    let type: String
    var x : Int
    var y : Int
    var hp = 200
    
    init(id: Int, type: String, x: Int, y: Int) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
    }
    
    func copy() -> Thing {
        return Thing(id: id, type: type, x: x, y: y)
    }
    
    var description: String {
        return "\(type)\(id) at (\(x), \(y)) with \(hp)"
    }
    
    func hit(world: inout [[String]]) -> Int? {
        hp -= 3
        if hp < 0 {
            world[y][x] = "."
            return id
        }
        return nil
    }
    
    func targetable(world: [[String]]) -> Bool {
        return world[y-1][x] == "." || world[y][x-1] == "." || world[y][x+1] == "." || world[y+1][x] == "."
    }
    
    func takeTurn(elves: [Thing], goblins: [Thing], world: inout [[String]]) -> Int? {
        //select target
        var enemies = type == "G" ? elves : goblins
        var targets = [(Thing, [(Int,Int)])]()
        var targetDis = Int.max - 1
        enemies.sort { (first, second) -> Bool in
            let dist1 = abs(first.x - x) + abs(first.y - y)
            let dist2 = abs(second.x - x) + abs(second.y - y)
            return dist1 < dist2
        }
        
        //distance calculation needs to be done¬
        
        
        for enemy in enemies {
            print("from \(self) to \(enemy) with max \(targetDis)")
            if let path = path(from: self, to: enemy, withMaxMoves: targetDis, inWorld: world) {
                let distance = path.count
                if distance == targetDis {
                    targets.append((enemy, path))
                } else if distance < targetDis {
                    targets = [(enemy, path)]
                    targetDis = distance
                }
            }
        }
        
        //move
        if targetDis > 0 && targets.count > 0 {
            targets.sort(by: readOrder)
            let mvTarget = targets[0].1.first!
            
            world[y][x] = "."
            x = mvTarget.0
            y = mvTarget.1
            world[y][x] = type
            targetDis -= 1
        }
        
        //attack
        if targetDis == 0 && targets.count > 0 {
            var option = targets.map{$0.0}
            option.sort{$0.hp != $1.hp ? $0.hp < $1.hp : ($0.y == $1.y ? $0.x < $1.x : $0.y < $1.y)}
            return option[0].hit(world: &world)
        }
        return nil
    }
}
