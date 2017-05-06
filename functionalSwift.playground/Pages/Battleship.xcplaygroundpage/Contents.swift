//: Playground - noun: a place where people can play

import UIKit

var str = "Battleship"

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func within(range: Distance) -> Bool {
        return sqrt(x * x +  y * y) <= range
    }
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}


// 目标船只在攻击范围内
extension Ship {
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
}

// 目标船只在攻击范围内， 且离自己的距离满足安全距离
extension Ship {
    func canSafelyEnage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
}


// 目标船只在攻击范围内，且离自己和友军的距离满足安全距离
extension Ship {
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        let friendlyDx = friendly.position.x - position.x
        let friendlyDy = friendly.position.y - position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}
// 上面的逻辑会越来越复杂了。我们试图定义一些工具函数来简化，方便后期维护。


// 求两个向量的差
// 求向量的距离
extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var lenght: Double {
        return sqrt(x * x + y * y)
    }
    
}


// 利用工具函数（求两点之间的向量，和距离）来简化函数
extension Ship {
    func canSafelyEngage2(ship target: Ship,friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).lenght
        let friendlyDistance = friendly.position.minus(target.position).lenght
        return targetDistance <= firingRange
            && targetDistance > unsafeRange
            && (friendlyDistance > unsafeRange)
    }
}
// 现在代码比之前的简单多了，但是我们还想声明的方式来明确现有的问题


