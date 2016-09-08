//
//  NodeIndex.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation

protocol NodeIndexProtocol {}
public struct NodeIndex: NodeIndexProtocol {
    public let x:Int!
    public let y:Int!
    
    func neighbors() -> [NodeIndex] {
        var n = [NodeIndex]()
        for i in -1...1 {
            for j in -1...1 {
                if !(i == 0 && j == 0) {
                    n.append(NodeIndex(x: x + i, y: y + j))
                }
            }
        }
        return n
    }
}
