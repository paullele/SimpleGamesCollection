//
//  MenuViewController.swift
//  Practice
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TTTMenuViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "computerFirst":
                if let viewController = segue.destination as? TTTGameViewController {
                    viewController.computerGoesFirst = true
                }
            case "playerFirst":
                if let viewController = segue.destination as? TTTGameViewController {
                    viewController.computerGoesFirst = false
                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func unwindToTTTMenu(segue: UIStoryboardSegue){}
}
