//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

// 创建更加模块化的解决方案。

// 之前的问题归结是：定义一个函数判断一个点是否是在范围内
struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var lenght: Double {
        return sqrt(x * x + y * y)
    }
    
}


func pointRange(point: Position) -> Bool {
    return true;
}

typealias  Region = (Position) -> Bool
typealias  Distance = Double

// 定义一个圆形
func cicrle(radius: Distance) -> Region {
    return {point in  point.lenght <= radius } // 编译器知道point 类型是 Position
}

// 传入一个函数，然后对它的参数进行处理，返回就成了一个新的函数了。
func shift( _ region: @escaping Region, by offset: Position) -> Region {
    return {point in region(point.minus(offset))}
}

// 我们创建一个圆心为在（5，5） 半径为 10的 圆
let shifted = shift(cicrle(radius: 10), by: Position(x:5,y:5))


// 两个区域的交际和并集，差集
func interset(_ region: @escaping Region, with other: @escaping Region) -> Region
{
return { point in region(point) && other(point)}
}

func union( _ region: @escaping Region, with other: @escaping Region) -> Region
{
    return { point in region(point) || other(point)}
}

// 区域外面
func invert(_ region: @escaping Region) -> Region
{
    return {point in !region(point) }
    
}

func subtract( _ region: @escaping Region,
               from original :@escaping Region) -> Region
{
    return interset(original, with: invert(region))
}

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}

extension Ship {
    func canSafelyEngage(ship target:Ship,friendly:Ship) -> Bool
    {
        let rangeRegion = subtract(cicrle(radius: unsafeRange), from: cicrle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        let friendlyRegion = shift(cicrle(radius: unsafeRange), by: friendly.position)
        let resultRegion = subtract(friendlyRegion, from: firingRegion)
        return resultRegion(target.position)
    }
}

print("end")
