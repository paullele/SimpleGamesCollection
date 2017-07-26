//
//  NPDataSource.swift
//  SimpleGamesCollection
//
//  Created by apple on 24/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

protocol NPDataSource {
    func constructObjectRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, storeIn arrayOfObjs: inout [UIButton], withTag tag: inout Int)
    
    func constructTheGrid(gridSize: CGFloat, bound: Int, originX: inout CGFloat, originY: inout CGFloat, pWidth: inout CGFloat, pHeight: inout CGFloat)
}
