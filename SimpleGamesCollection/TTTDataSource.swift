//
//  TTTDataSource.swift
//  SimpleGamesCollection
//
//  Created by apple on 02/08/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

protocol TTTDataSource {
    func constructObjectRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, storeIn arrayOfObjs: inout [UIButton], withTag tag: inout Int)
    
    func constructTheGrid(gridSize: CGFloat, originX: inout CGFloat, originY: inout CGFloat, pWidth: CGFloat, pHeight: CGFloat, arrayOfObjs: inout [UIButton], tagCount: inout Int)
}
