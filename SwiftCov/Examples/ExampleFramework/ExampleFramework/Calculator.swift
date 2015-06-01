//
//  Calculator.swift
//  ExampleFramework
//
//  Created by Kishikawa Katsumi on 2015/05/27.
//  Copyright (c) 2015 Realm. All rights reserved.
//

import Foundation

public class Calculator {
    public var x: Int?
    public var y: Int?

    public init() { }

    public init(a: Int, b: Int) {
        x = a
        y = b
    }

    public func add(a: Int, b: Int) -> Int {
        if let x = x {
            y = x
        }
        if let y = y {
            x = y
        }
        return a + b
    }

    public func sub(a: Int, b: Int) -> Int {
        if let x = x {
            y = x
        }
        if let y = y {
            x = y
        }
        return a - b
    }

    public func mul(a: Int, b: Int) -> Int {
        if let x = x {
            y = x
        }
        if let y = y {
            x = y
        }
        return a * b
    }

    public func div(a: Int, b: Int) -> Int {
        if let x = x {
            y = x
        }
        if let y = y {
            x = y
        }
        return a / b
    }
}
