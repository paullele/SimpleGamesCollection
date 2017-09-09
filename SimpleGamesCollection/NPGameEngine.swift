//
//  Engine.swift
//  NumbersPuzzle
//
//  Created by apple on 17/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

class NPGameEngine: NSObject {
    
    override init() {
        super.init()
    }
    
    var index = 0
    
    func generateNumber(upperBound x: Int) -> Int {
        let value = Int(arc4random_uniform(UInt32(x))) + 1
        return value
    }
    
    func verifyPuzzlePieces(against value: Int, piece item: [Int], upTo bound: Int) -> Bool {
        for i in 0 ..< bound {
            if item[i] == value {
                return false
            }
        }
        
        return true
    }
    
    func generatePuzzle(piece item: inout [Int], upTo bound: Int) {
        while index < bound {
            
            let newValue = generateNumber(upperBound: bound)
            
            if verifyPuzzlePieces(against: newValue, piece: item, upTo: index) {
                item.append(newValue)
                index += 1
            }
        }
    }
}
