//
//  GridGameDataSource.swift
//  SimpleGamesCollection
//
//  Created by apple on 02/08/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

protocol GridGameDataSource {
    func createCell(at x: CGFloat, y: CGFloat, ofSize size: CGFloat, to view: UIView)
    func populateBoard()
}
