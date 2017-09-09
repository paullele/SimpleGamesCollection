//
//  SticksEngine.swift
//  21Sticks
//
//  Created by apple on 20/11/2016.
//  Copyright © 2016 apple. All rights reserved.
//

import Foundation

class TOGameEngine {
    
    func takeSticks(_ number: Int) -> Int {
        if ((number - 2) % 3 == 0 || number - 2 == 0 || number == 1) {
            return 1
        } else {
            return 2
        }
    }
}
