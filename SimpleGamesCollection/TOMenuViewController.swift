//
//  GameMenu.swift
//  21Sticks
//
//  Created by apple on 21/11/2016.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class TOMenuViewControlelr: UIViewController {
    
    @IBAction func singlePlayer(_ sender: UIButton) {
        let alert = UIAlertController(title: "21 sticks", message: "Would you like to go first?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { [unowned self]
            action in
            
            self.handleSegueComputer(first: false)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { [unowned self]
            action in
            
            self.handleSegueComputer(first: true)
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func multiPlayer(_ sender: UIButton) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "TOGameViewController") as! TOGameViewController
        gameViewController.singlePlayer = false
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    func handleSegueComputer(first: Bool) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "TOGameViewController") as! TOGameViewController
        
        gameViewController.computerGoesFirst = first
        gameViewController.playersTurn = !first
        
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @IBAction func unwindToTOMenu(segue: UIStoryboardSegue) {}
}
