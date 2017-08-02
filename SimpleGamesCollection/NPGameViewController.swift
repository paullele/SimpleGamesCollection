//
//  ViewController.swift
//  NumbersPuzzle
//
//  Created by apple on 17/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class NPGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var bound = 0
    var gridSize: CGFloat = 3
    var container = [UIButton]()
    var cellTag = 0;
    fileprivate var puzzleArray: [Int] = []
    
    var cellSize: CGFloat = 100
    var startX: CGFloat!
    var startY: CGFloat!
    
    private let gameEninge = NPGameEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cellSize = CGFloat(Int(self.view.frame.width)/Int(gridSize)) - 10
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
        //generate the puzzle
        
        gameEninge.generatePuzzle(piece: &puzzleArray, upTo: bound)
        
        //set the grid origins
        startX = self.view.frame.width/2 - ((cellSize * gridSize) / 2)
        startY = self.view.frame.height/2 - ((cellSize * gridSize) / 2)
        
        //construct the grid
        populateBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (navigationController?.viewControllers.count)! > 1 {
            handleUnwindToMenu()
        }
        return false
    }
    
    @objc private func handleUnwindToMenu() {
        let action = UIAlertController(title: nil, message: "Are you sure you want to start a new game?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            action in
            
            self.performSegue(withIdentifier: "unwindToNPMenu", sender: UIBarButtonItem())
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        action.addAction(yesAction)
        action.addAction(noAction)
        self.present(action, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NPGameViewController: GridGameDelegate {
    
    func performMove(from piece1: UIButton, to piece2: UIButton) {
        piece2.setTitle(piece1.currentTitle, for: UIControlState())
        piece1.setTitle("", for: UIControlState())
    }
    
    func actionOnSender(_ sender: AnyObject) {
        
        let sender = sender as! UIButton
        
        let slotTag = sender.tag
        var changed = false
        
        if slotTag + 1 % Int(gridSize) == 0 {
            
            if slotTag + Int(gridSize) < bound + 1 {
                if container[slotTag + Int(gridSize)].currentTitle == ""   {
                    performMove(from: sender, to: container[slotTag + Int(gridSize)])
                    changed = true
                }
            }
            
            if slotTag - 1 >= 0 && !changed {
                if container[slotTag - 1].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag - 1])
                    changed = true
                }
            }
            
            if slotTag - Int(gridSize) >= 0 && !changed {
                if container[slotTag - Int(gridSize)].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag - Int(gridSize)])
                    changed = true
                }
            }
        }
            
        else if slotTag % Int(gridSize) == 0 {
            
            if slotTag + Int(gridSize) < bound + 1 {
                if container[slotTag + Int(gridSize)].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag + Int(gridSize)])
                    changed = true
                }
            }
            
            if slotTag + 1 < bound + 1 && !changed {
                if container[slotTag + 1].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag + 1])
                    changed = true
                }
            }
            
            if slotTag - Int(gridSize) >= 0 && !changed {
                if container[slotTag - Int(gridSize)].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag - Int(gridSize)])
                    changed = true
                }
            }
        }
            
        else {
            
            if slotTag + Int(gridSize) < bound + 1 {
                if container[slotTag + Int(gridSize)].currentTitle == ""   {
                    performMove(from: sender, to: container[slotTag + Int(gridSize)])
                    changed = true
                }
            }
            
            if slotTag - 1 >= 0 && !changed {
                if container[slotTag - 1].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag - 1])
                    changed = true
                }
            }
            
            if slotTag - Int(gridSize) >= 0 && !changed {
                if container[slotTag - Int(gridSize)].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag - Int(gridSize)])
                    changed = true
                }
            }
            
            if slotTag + 1 < bound + 1 && !changed {
                if container[slotTag + 1].currentTitle == ""  {
                    performMove(from: sender, to: container[slotTag + 1])
                    changed = true
                }
            }
        }
    }
}

extension NPGameViewController: GridGameDataSource {
    
    func createCell(at x: CGFloat, y: CGFloat, ofSize size: CGFloat, to view: UIView) {
        let cell = UIButton(frame: CGRect(x: x, y: y, width: size, height: size))
        
        cell.addTarget(self, action: #selector(actionOnSender), for: .touchUpInside)
        cell.setTitleColor(UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        cell.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.tag = cellTag
        view.addSubview(cell)
        container.append(cell)
        
        cellTag += 1
    }
    
    func populateBoard() {
        for _ in 0..<Int(gridSize) {
            for _ in 0..<Int(gridSize) {
                createCell(at: startX, y: startY, ofSize: cellSize, to: self.view)
                startX = startX + cellSize
            }
            startX = startX - (cellSize * CGFloat(gridSize))
            startY = startY + cellSize
        }
        
        //populate the grid objects
        for i in 0 ..< bound {
            container[i].setTitle(String(puzzleArray[i]), for: UIControlState())
        }
        
        container.last?.setTitle("", for: UIControlState())
    }
}

