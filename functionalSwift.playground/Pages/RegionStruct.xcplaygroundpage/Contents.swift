//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

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

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}


func pointRange(point: Position) -> Bool {
    return true;
}

typealias  Distance = Double

struct Region {
    let lookup: (Position) -> Bool
}

extension Region
{
    func shift(by offset: Position) -> Region {
        let mylookup:(Position)->Bool = {
            p in
            self.lookup(p.minus(offset))
        }
        
        var result = Region(lookup: mylookup)
        return result;
    
    }
    
    
    // 定义一个圆形
    func cicrle(radius: Distance) -> Region {
        let mylookup:(Position) -> Bool =  {point in  point.lenght <= radius } // 编译器知道point 类型是 Position
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

}

print("doubt")

// Doubt
