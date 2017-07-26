//
//  NPDelegate.swift
//  SimpleGamesCollection
//
//  Created by apple on 24/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

protocol NPDelegate {
    func setProperties(for item: UIButton, andTag tagID: Int)
    func performMove(from piece1: UIButton, to piece2: UIButton)
    func onPuzzlePiece(_ sender: UIButton)
}
