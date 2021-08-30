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

extension Region {
    func shift(by offset: Position) -> Region {
        let mylookup:(Position)->Bool = {
            p in
            self.lookup(p.minus(offset))
        }
        
        let result = Region(lookup: mylookup)
        return result;
    }
    
    
    // 定义一个圆形
    func cicrle(radius: Distance) -> Region {
        let mylookup:(Position) -> Bool =  {point in  point.lenght <= radius } // 编译器知道point 类型是 Position
        return Region.init(lookup: mylookup)
    }



    // 两个区域的交际和并集，差集
    func interset(  other:Region) -> Region {
        let mylookup:(Position)->Bool = {
            p in
            return self.lookup(p) && other.lookup(p)
        }
        
        return Region(lookup: mylookup)
    }

    func union(_ other:Region) -> Region {
        let mylookup:(Position)->Bool = {
            p in
            self.lookup(p) || other.lookup(p)
        }
        
        return Region(lookup: mylookup)
    }

    // 区域外面
    func invert() -> Region {
        let mylookup:(Position)->Bool = {
            p in
            return !self.lookup(p)
        }
        
        return Region(lookup: mylookup)
    }

    func subtract( _ region:Region) -> Region {
        return self.interset(other: region.invert())
    }
    

}

print("doubt")
