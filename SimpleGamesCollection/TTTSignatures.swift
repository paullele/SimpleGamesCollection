//
//  Signatures.swift
//  Practice
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation

class TTTSignatures {
    
    private var playerSignature: String!
    private var computerSignature: String!
    
    init(playerSignature: String, computerSignature: String) {
        self.playerSignature = playerSignature
        self.computerSignature = computerSignature
    }
    
    var getPlayerSig: String {
        return playerSignature
    }
    
    var getComputerSig: String {
        return computerSignature
    }
}
