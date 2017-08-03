//
//  MenuViewController.swift
//  Practice
//
//  Created by apple on 21/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TTTMenuViewController: UIViewController {
    
    @IBAction func singlePlayer(_ sender: UIButton) {
        let alert = UIAlertController(title: "Tic Tac Toe", message: "Would you like to go first", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            action in self.handleSegueComputer(first: false)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            action in self.handleSegueComputer(first: true)
        })
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func multiPlayer(_ sender: UIButton) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "TTTGameViewController") as! TTTGameViewController
        
        gameViewController.singlePlayer = false
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    func handleSegueComputer(first: Bool) {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "TTTGameViewController") as! TTTGameViewController
        gameViewController.computerGoesFirst = first
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @IBAction func unwindToTTTMenu(segue: UIStoryboardSegue){}
}
