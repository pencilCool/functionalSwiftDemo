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
}

print("doubt")

// Doubt
