//
//  MSCell.swift
//  SimpleGamesCollection
//
//  Created by apple on 22/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class MSCell: UIButton {
    var visited: Bool!
    
    init(frame: CGRect, visited: Bool) {
        super.init(frame: frame)
        self.visited = visited
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
