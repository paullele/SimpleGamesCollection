//
//  GameMenu.swift
//  21Sticks
//
//  Created by apple on 21/11/2016.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class TOMenuViewControlelr: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? TOGameViewController {
            if segue.identifier == "playerFirst" {
                viewController.computerGoesFirst = false;
                viewController.playersTurn = true;
            } else if segue.identifier == "computerFirst" {
                viewController.computerGoesFirst = true;
                viewController.playersTurn = false;
            }
        }
    }
    
    @IBAction func unwindToTOMenu(segue: UIStoryboardSegue) {}
}
