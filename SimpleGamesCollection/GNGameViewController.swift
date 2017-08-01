//
//  ViewController.swift
//  GuessTheNumber
//
//  Created by apple on 11/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class GNGameViewController: UIViewController {
    
    var range: Int?
    var tips: Bool?
    var attempts: Int?
    private let gameLogic = GNGameEngine()
    private var secretNumber: Int?
    private var gameEnded = false
    
    
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var guessingBox: UITextField!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var attemptsStatus: UILabel!
    
    var getGuess: Int {
        get {
            if let guess = Int(guessingBox.text!) {
                return guess
            } else {
                return -1
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleUnwindToMenu))
        self.navigationItem.leftBarButtonItem = backButton
        
        gameStatus.text = "Your guess is..."
        secretNumber = gameLogic.generateNumber(upTo: range!)
        attemptsStatus.text = String(attempts!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func manageEndGame() {
        guessButton.isUserInteractionEnabled = false
        gameEnded = true
        guessingBox.resignFirstResponder()
        guessingBox.isUserInteractionEnabled = false
    }
    
    @IBAction func onGuessButton(_ sender: UIButton) {

        if getGuess >= 0 {
            if(getGuess == secretNumber) {
                gameStatus.text = "Correct!"
                manageEndGame()
                
            } else {
                gameStatus.text = gameLogic.giveTipMessage(tipsAllowed: tips!, guessing: getGuess, secret: secretNumber!)
                guessingBox.text = nil
                gameLogic.checksAttempts(&attempts!)
                attemptsStatus.text! = String(attempts!)
                
                if gameLogic.gameOver(attempts!) {
                    gameStatus.text = "Game Over"
                    manageEndGame()
                }
            } 
        }
    }
    
    @objc func handleUnwindToMenu() {
        
        if gameEnded {
            self.performSegue(withIdentifier: "unwindToGNMenu", sender: nil)
        } else {
            let alert = UIAlertController(title: "Are you sure you want to start a new game?", message: nil, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
                action in self.performSegue(withIdentifier: "unwindToGNMenu", sender: nil)
            })
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

