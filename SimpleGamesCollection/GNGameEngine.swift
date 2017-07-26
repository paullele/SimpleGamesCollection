//
//  GameLogic.swift
//  GuessTheNumber
//
//  Created by apple on 12/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation

class GNGameEngine {
    
    func generateNumber(upTo range: Int) -> Int {
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    func giveTipMessage(tipsAllowed tips: Bool, guessing numberGiven: Int, secret numberToGuess: Int) -> String {
        if tips {
            if numberGiven > numberToGuess {
                return "Too high..."
            } else {
                return "Too low..."
            }
        } else {
            return "Guess again..."
        }
    }
    
    func gameOver(_ attempts: Int) -> Bool {
        if attempts == 0 {
            return true
        } else {
            return false
        }
    }

    func checksAttempts( _ attempts: inout Int) {
        attempts -= 1
    }
}
