//
//  ViewController.swift
//  Practice
//
//  Created by apple on 17/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TTTGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var displayGameStatus: UILabel!
    
    let gridSize: CGFloat = 3
    private var signaturesInit: TTTSignatures!
    private var gameEnded = false
    var cellSize: CGFloat!
    
    let gameEngine = TTTGameEngine()
    
    var k = 0
    var drawingBoard: UIView!
    var container = [UIButton]()
    var startX: CGFloat!
    var startY: CGFloat!
    
    var computerSignature: String {
        get {
            return signaturesInit.getComputerSig
        }
    }
    
    var playerSignature: String {
        get {
            return signaturesInit.getPlayerSig
        }
    }
    
    var computerGoesFirst: Bool?
    
    @objc private func handleUnwindToMenu() {
        
        if !gameEnded {
            
            let controller = UIAlertController(title: "Are you sure you want to start a new game?", message: nil, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes, I'm sure!", style: .destructive, handler: {
                
                action in
                
                self.performSegue(withIdentifier: "unwindToTTTMenu", sender: nil)
                
            })
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            controller.addAction(yesAction)
            controller.addAction(noAction)
            
            present(controller, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "unwindToTTTMenu", sender: nil)
        }
    }
    
    private func disableButtons() {
        for item in container {
            item.isUserInteractionEnabled = false
        }
    }
    
    func searchWinner(_ k: Int) -> Bool {
        
        if k > 4 {
            if gameEngine.existsWinner(container, playerSignature) {
                disableButtons()
                displayGameStatus.text = "Player won"
                gameEnded = true
                return true
            }
            else if gameEngine.existsWinner(container, computerSignature) {
                disableButtons()
                displayGameStatus.text = "Computer won"
                gameEnded = true
                return true
            }
            else if k == 9 {
                disableButtons()
                displayGameStatus.text = "Tie"
                gameEnded = true
                return true
            }
        }
        
        return false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (navigationController?.viewControllers.count)! > 1 {
            handleUnwindToMenu()
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingBoard = TTTDrawingBoard(frame: self.view.frame)
        drawingBoard.backgroundColor = UIColor.white
        
        self.view.addSubview(drawingBoard);
        
        self.drawingBoard.addSubview(displayGameStatus)
        
        self.navigationController?.isNavigationBarHidden = true
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        cellSize = CGFloat((Int(self.view.frame.width) - (Int(self.view.frame.width) % 100))/Int(gridSize))
                
        //set the grid origins
        startX = ((self.view.frame.width/2 - ((cellSize * gridSize) / 2)))
        startY = ((self.view.frame.height/2 - ((cellSize * gridSize) / 2)))
        
        //construct the grid interactive cells
        populateBoard()
        
        if computerGoesFirst! {
            signaturesInit = TTTSignatures(playerSignature: "0", computerSignature: "X")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.gameEngine.searchPosition(self.container, self.computerSignature, self.playerSignature)
                self.k += 1
            })
        }
        else {
            signaturesInit = TTTSignatures(playerSignature: "X", computerSignature: "0")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension TTTGameViewController: GridGameDelegate {
    
    func actionOnSender(_ sender: AnyObject) {
        let sender = sender as! UIButton
        if sender.currentTitle != playerSignature && sender.currentTitle != computerSignature {
            
            sender.setTitle(playerSignature, for: UIControlState())
            k += 1
            
            if !searchWinner(k) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.gameEngine.searchPosition(self.container, self.computerSignature, self.playerSignature)
                    
                    self.k += 1
                    
                    _ = self.searchWinner(self.k)
                    
                })
            }
        }
    }
}

extension TTTGameViewController: GridGameDataSource {
    
    func createCell(at x: CGFloat, y: CGFloat, ofSize size: CGFloat, to view: UIView) {
        
        let cell = UIButton(frame: CGRect(x: x, y: y, width: size, height: size))
        cell.addTarget(self, action: #selector(actionOnSender), for: .touchUpInside)
        cell.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        cell.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        cell.layer.borderColor = UIColor.black.cgColor
        container.append(cell)
        view.addSubview(cell)
    }
    
    func populateBoard() {
        
        for _ in 0 ..< Int(gridSize) {
            for _ in 0 ..< Int(gridSize) {
                createCell(at: startX, y: startY, ofSize: cellSize, to: self.drawingBoard)
                startX = startX + cellSize
            }
            
            startX = startX - (cellSize * gridSize)
            startY = startY + cellSize
        }
    }
}

