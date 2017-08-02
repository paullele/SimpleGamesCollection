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
    
    private var drawingBoard: UIView!
    
    private let gridSize: CGFloat = 3
    private var container = [UIButton]()
    private let gameEngine = TTTGameEngine()
    
    private var signaturesInit: TTTSignatures!
    private var gameEnded = false
    
    private var k = 0
    private var tagCount = 0
    
    private var pWidth: CGFloat!
    private var pHeight: CGFloat!
        
    private var computerSignature: String {
        get {
            return signaturesInit.getComputerSig
        }
    }
    
    private var playerSignature: String {
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
    
    @objc fileprivate func onField(_ sender: UIButton) {
        
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
    
    private func disableButtons() {
        for item in container {
            item.isUserInteractionEnabled = false
        }
    }
    
    private func searchWinner(_ k: Int) -> Bool {
        
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
        
        pWidth = CGFloat((Int(self.view.frame.width) - (Int(self.view.frame.width) % 100))/Int(gridSize))
        pHeight = pWidth
                
        //set the grid origins
        var originX = ((self.view.frame.width/2 - ((pWidth * gridSize) / 2)))
        var originY = ((self.view.frame.height/2 - ((pHeight * gridSize) / 2)))
        
        //construct the grid interactive cells
        constructTheGrid(gridSize: gridSize, originX: &originX, originY: &originY, pWidth: pWidth, pHeight: pHeight, arrayOfObjs: &container, tagCount: &tagCount)
        
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

extension TTTGameViewController: TTTDelegate {
    
    func setProperties(for item: UIButton, andTag tagID: Int) {
        item.addTarget(self, action: #selector(onField), for: .touchUpInside)
        item.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        item.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        item.tag = tagID
        item.layer.borderColor = UIColor.black.cgColor
    }
}

extension TTTGameViewController: TTTDataSource {
    
    func constructObjectRect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, storeIn arrayOfObjs: inout [UIButton], withTag tag: inout Int) {
        
        let obj = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        setProperties(for: obj, andTag: tag)
        arrayOfObjs.append(obj)
    }
    
    func constructTheGrid(gridSize: CGFloat, originX: inout CGFloat, originY: inout CGFloat, pWidth: CGFloat, pHeight: CGFloat, arrayOfObjs: inout [UIButton], tagCount: inout Int) {
        
        for _ in 0 ..< Int(gridSize) {
            for _ in 0 ..< Int(gridSize) {
                constructObjectRect(x: originX, y: originY, width: pWidth, height: pHeight, storeIn: &arrayOfObjs, withTag: &tagCount)
                
                originX += pWidth
            }
            
            originX -= (pWidth * gridSize)
            originY += pHeight
        }
        
        //add grid components to the view
        for item in arrayOfObjs {
            self.view.addSubview(item)
        }
    }
}

