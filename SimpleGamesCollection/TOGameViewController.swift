//
//  ViewController.swift
//  21Sticks
//
//  Created by apple on 20/11/2016.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit

class TOGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sticksLeft: UILabel!
    @IBOutlet weak var displayMessage: UITextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    private var game = TOGameEngine()
    var computerGoesFirst = false
    var playersTurn = true;
    
    fileprivate var gameEnded = false
    
    private var numberOfSticks: Int = 21 {
        didSet {
            updateSticksLeft(with: numberOfSticks)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleUnwindToMenu))
        
        self.navigationItem.leftBarButtonItem = backButton
        
        managePlayersButtons()
        
        if computerGoesFirst {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.computerTakesSticks()
            })
        }
    }
    
    func updateSticksLeft(with number: Int) {
        sticksLeft.text = String(number)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (navigationController?.viewControllers.count)! > 1 {
            handleUnwindToMenu()
        }
        return false
    }
    
    private func managePlayersButtons() {
        
        if playersTurn {
            button1.isEnabled = true
            button2.isEnabled = true
        } else {
            button1.isEnabled = false
            button2.isEnabled = false
        }
    }
    
    
    @IBAction func takeSticks(_ sender: UIButton) {
        
        let takenNumber = Int(sender.currentTitle!)
        
        numberOfSticks -= takenNumber!
        
        if takenNumber == 1 {
            displayMessage.text = "Player takes 1 stick"
        } else {
            displayMessage.text = "Player takes 2 sticks"
        }
        
        if numberOfSticks <= 0 {
            displayMessage.text = "Computer wins"
            gameEnded = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.computerTakesSticks()
            })
        }
        
        playersTurn = false
        managePlayersButtons()
    }
    
    
    @objc func handleUnwindToMenu() {
        
        if gameEnded {
            performSegue(withIdentifier: "unwindToTOMenu", sender: UIButton())
        } else {
            let alert = UIAlertController(title: "Are you sure you want to start a new game?", message: nil, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
                action in self.performSegue(withIdentifier: "unwindToTOMenu", sender: nil)
            })
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func computerTakesSticks() {
        
        let computerTakesSticks = game.takeSticks(numberOfSticks)

        numberOfSticks -= computerTakesSticks
        
        if computerTakesSticks == 1 {
            displayMessage.text = "Computer takes 1 stick"
        } else {
            displayMessage.text = "Computer takes 2 sticks"
        }
        
        if numberOfSticks <= 0 {
            gameEnded = true
            displayMessage.text = "Player wins"
            playersTurn = false
            managePlayersButtons()
        }
        
        playersTurn = true
        managePlayersButtons()
    }
}

