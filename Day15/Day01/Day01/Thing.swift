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
    static var elfPower = 3
    
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
        if type == "E" {
            hp -= 3
        } else {
            hp -= Thing.elfPower
        }
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
        var targets = [(Thing, (Int,Int))]()
        var targetDis = Int.max
        enemies.sort { (first, second) -> Bool in
            let dist1 = abs(first.x - x) + abs(first.y - y)
            let dist2 = abs(second.x - x) + abs(second.y - y)
            return dist1 < dist2
        }
        
        //distance calculation needs to be done¬
        let travelMap = travelMapfor(x: x, y: y, world: world)
        for enemy in enemies {
            let coords = [(enemy.x, enemy.y - 1),
                          (enemy.x - 1, enemy.y),
                          (enemy.x + 1, enemy.y),
                          (enemy.x, enemy.y + 1)]
            for (ex, ey) in coords {
                if travelMap[ey][ex] < targetDis {
                    targetDis = travelMap[ey][ex]
                    targets = [(enemy, (ex, ey))]
                } else if travelMap[ey][ex] == targetDis {
                    targets.append((enemy, (ex, ey)))
                }
            }
        }
        
        var path = [(Int, Int)]()
        if targetDis > 0 && targetDis < Int.max {
            targets.sort(by: readOrder)
            var (mx, my) = targets[0].1
            //find path to chosen enemy
            path.append((mx, my))
            while travelMap[my][mx] > 1 {
                let coords = [(mx, my - 1),
                              (mx - 1, my),
                              (mx + 1, my),
                              (mx, my + 1)]
                var selected = (0, 0)
                var distance = Int.max
                for (cx, cy) in coords {
                    if distance > travelMap[cy][cx] {
                        distance = travelMap[cy][cx]
                        selected = (cx, cy)
                    }
                }
                path.append(selected)
                mx = selected.0
                my = selected.1
            }
        }
        
        //move
        if path.count > 0 {
            world[y][x] = "."
            x = path.last!.0
            y = path.last!.1
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
