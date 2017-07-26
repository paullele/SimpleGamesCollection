//
//  MSDataSource.swift
//  SimpleGamesCollection
//
//  Created by apple on 23/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

protocol MSDataSource {
    func measurementsInitializer(startX: CGFloat, startY: CGFloat, cellSize: CGFloat, cellsPerRow: Int)    
    func createCell(at x: CGFloat, y: CGFloat, ofSize size: CGFloat, to view: UIView)
    func populateBoard(view: UIView)
    func plantMines()
}
