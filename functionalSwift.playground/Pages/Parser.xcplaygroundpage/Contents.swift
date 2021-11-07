//: [Previous](@previous)

import Foundation
import UIKit


struct Parser<Result> {
    typealias Stream = Substring
    let parse:(Stream) -> (Result,Stream)?
}

func character(matching condition: @escaping (Character) -> Bool) -> Parser<Character> {
    //
    return Parser<Character> {
        input in
        guard let char = input.first, condition(char) else {
            return nil
        }
        return (char,input.dropFirst())
    }
}

let one = character {
    $0 == "1"
}

one.parse("124")

extension CharacterSet {
    func contains(_ c:Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else {
            return false
        }
        return contains(scalars.first!)
    }
}

let digit = character {
    CharacterSet.decimalDigits.contains($0)
}

digit.parse("456")

extension Parser {
    var many:Parser<[Result]> {
        return Parser<[Result]> {
            input in
            var result:[Result] = []
            var remainder = input
            while let(element,newRemainder) = self.parse(remainder) {
                result.append(element)
                remainder = newRemainder
            }
            return (result,remainder)
        }
    }
}

digit.many.parse("123")
extension Parser {
    func map<T>(_ transform:@escaping (Result)->T) -> Parser<T> {
        return Parser<T> {
            input in
            guard let (result,remainder) = self.parse(input) else {
                return nil
            }
            return (transform(result),remainder)
        }
    }
}

let integer = digit.many.map{Int(String($0))!}
integer.parse("123")


extension Parser {
    func follwed<A>(by other:Parser<A>) -> Parser<(Result,A)> {
        return Parser<(Result,A)> {
            input in
            guard let (result1,remainder1) = self.parse(input) else {
                return nil
            }
            
            guard let (result2,remainder2) = other.parse(remainder1) else {
                return nil
            }
            
            return ((result1,result2),remainder2)
        }
    }
}

let multiplication = integer.follwed(by: character{$0 == "*"}).follwed(by: integer)
multiplication.parse("2*3")

let multiplication2 = multiplication.map {
    $0.0 * $1
}

multiplication2.parse("2*3")

func multiply(lhs:(Int,Character),rhs:Int) -> Int {
    return lhs.0 * rhs
}

func multiply(_ x:Int, _ op:Character, _ y:Int) -> Int {
    return x * y
}

func curriedMultiply(_ x:Int) -> (Character) -> (Int) -> Int {
    return {
        op in
        return {
            y in
            return x * y
        }
    }
}

curriedMultiply(2)("*")(3)

func curry<A,B,C>(_ f:@escaping (A,B)->C) -> (A) ->(B) -> C {
    return {
        a in {
            b in
            f(a,b)
        }
    }
}

let p1 = integer.map(curriedMultiply)
let p2 = p1.follwed(by: character{$0 == "*"})
let p3 = p2.map{ f,op in f(op)}
let p4 = p3.follwed(by: integer)
let p5 = p4.map{f,y in f(y)}
var p5R = p5.parse("2*3")
print(p5R)

let p7 = p1.follwed(by: character{$0 == "*"}).map{
    f,op in f(op)
}.follwed(by: integer).map { f,y in
    f(y)
}


