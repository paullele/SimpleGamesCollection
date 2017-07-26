//
//  ViewController.swift
//  Hang
//
//  Created by apple on 26/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class HGameViewController: UIViewController {
    
    private var wordsContainer = [String]()
    private var totalWords: Int!
    private var wordToGuess: String!
    private var correctGuess = false
    private var arrayOfChars = [Character]()
    
    @IBOutlet weak var drawingBoard: HDrawingBoard!
    @IBOutlet weak var displayWord: UILabel!
    @IBOutlet var keysCollection: [UIButton]!
    @IBOutlet weak var gameStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newGame = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleNewGame))
        navigationItem.rightBarButtonItem = newGame
        
        let path = Bundle.main.path(forResource: "guesswords", ofType: "plist")
        let wordList = NSArray(contentsOfFile: path!)
        wordsContainer = wordList as! [String]
        
        totalWords = wordsContainer.count
        
        wordToGuess = assignWord(wordsContainer: wordsContainer, totalWords: totalWords)
        
        handleNewGame()
    }
    
    @IBAction func onKey(_ sender: UIButton) {
        
        displayWord.text = " "
        correctGuess = false
        var i = 0
        sender.isEnabled = false
        
        for char in wordToGuess.characters {
            
            if String(char) == sender.currentTitle! {
                arrayOfChars[i] = Character(sender.currentTitle!)
                displayWord.text = displayWord.text! + sender.currentTitle! + " "
                
                correctGuess = true
            } else {
                displayWord.text = displayWord.text! + String(arrayOfChars[i]) + " "
            }
            
            i += 1
        }
        
        if !correctGuess {
            drawingBoard.attempts += 1
            drawingBoard.setNeedsDisplay()
        }
        
        checkGameStatus()
    }
    
    private func assignWord(wordsContainer: [String], totalWords: Int) -> String {
        return wordsContainer[chooseWord(inRange: totalWords)]
    }
    
    private func chooseWord(inRange range: Int) -> Int {
        
        return Int(arc4random_uniform(UInt32(range)))
    }
    
    private func checkGameStatus() {
        
        var gameEnded = true
        
        if drawingBoard.attempts < 6 {
            
            for item in arrayOfChars {
                if item == "_" {
                    gameEnded = false
                }
            }
            
            if gameEnded {
                for key in keysCollection {
                    key.isEnabled = false
                }
                
                gameStatus.text = "You won!"
            }
            
        } else {
            
            displayWord.text = wordToGuess
            gameStatus.text = "Game Over"
            
            for key in keysCollection {
                key.isEnabled = false
            }
        }
    }
    
    @objc private func handleNewGame() {
        
        wordToGuess = assignWord(wordsContainer: wordsContainer, totalWords: totalWords)
        
        gameStatus.text = " "
        displayWord.text = " "
        arrayOfChars.removeAll()
        
        drawingBoard.attempts = 0
        drawingBoard.setNeedsDisplay()
        
        for _ in 0 ..< wordToGuess.characters.count {
            arrayOfChars.append("_")
            displayWord.text = displayWord.text! + "_ "
        }
        
        for key in keysCollection {
            key.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

