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
    
    private var drawingBoard: HDrawingBoard!
    
    @IBOutlet weak var displayWord: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    
    private var arrayOfObjs = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingBoard = HDrawingBoard(frame: self.view.frame)
        drawingBoard.backgroundColor = UIColor.white
        self.view.addSubview(drawingBoard)
        self.drawingBoard.addSubview(displayWord)
        self.drawingBoard.addSubview(gameStatus)
        
        let newGame = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleNewGame))
        navigationItem.rightBarButtonItem = newGame
        
        let path = Bundle.main.path(forResource: "guesswords", ofType: "plist")
        let wordList = NSArray(contentsOfFile: path!)
        wordsContainer = wordList as! [String]
        
        totalWords = wordsContainer.count
        
        createHangKeyboard(x: self.view.frame.width/2, y: self.view.frame.height)
        
        wordToGuess = assignWord(wordsContainer: wordsContainer, totalWords: totalWords)
        
        handleNewGame()
    }
    
    private func constructObjectRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, storeIn arrayOfObjs: inout [UIButton], withTag tag: inout Int) {
        
        let obj = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        setProperties(for: obj, andTag: tag)
        arrayOfObjs.append(obj)
    }
    
    private func setProperties(for item: UIButton, andTag tag: Int) {
        item.addTarget(self, action: #selector(onKey), for: .touchUpInside)
        item.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        item.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        item.layer.borderColor = UIColor.black.cgColor
        item.setTitle(String(UnicodeScalar(UInt8(tag))), for: .normal)
    }
    
    private func createHangKeyboard(x: CGFloat, y: CGFloat) {
        var tag = 97
        var y = y - 120
        
        for i in 0...2 {
            var x = x
            x = x - (30 * (9 - CGFloat(i)))/2
            
            for _ in 0..<9-i {
                constructObjectRect(x: x, y: y, width: 30, height: 30, storeIn: &arrayOfObjs, withTag: &tag)
                
                tag += 1
                x += 30
            }
            y += 30
        }
        
        for item in arrayOfObjs {
            drawingBoard.addSubview(item)
        }
    }
    
    @objc func onKey(_ sender: UIButton) {
        displayWord.text = " "
        correctGuess = false
        var i = 0
        sender.isEnabled = false
        sender.setTitleColor(UIColor.gray, for: .normal)
        
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
                for key in arrayOfObjs {
                    key.isEnabled = false
                }
                gameStatus.text = "You won!"
            }
        } else {
            displayWord.text = wordToGuess
            gameStatus.text = "Game Over"
            
            for key in arrayOfObjs {
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
        
        for key in arrayOfObjs {
            key.isEnabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

