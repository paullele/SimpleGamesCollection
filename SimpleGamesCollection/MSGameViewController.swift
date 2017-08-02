//
//  ViewController.swift
//  Minesweeper
//
//  Created by apple on 08/06/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class MSGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var mode = "normal"
    private var mRef: CGFloat!
    
    fileprivate var startX: CGFloat!
    fileprivate var startY: CGFloat!
    fileprivate var cellSize: CGFloat!
    fileprivate var cellsPerRow: Int!
    
    fileprivate var gameEnded = false
    
    fileprivate var gameEngine = MSGameEngine()

    @IBOutlet weak var displayGameStatus: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        mRef = CGFloat(Int(self.view.frame.width)/2) - 20
        
        gameEngine.computedCellsPerRow = 12
        cellsPerRow = 12
        
        measurementsInitializer(startX: self.view.frame.width/2 - mRef, startY: self.view.frame.height/2 - mRef, cellSize: mRef*2/CGFloat(cellsPerRow), cellsPerRow: cellsPerRow)
        
        populateBoard(view: self.view)
        plantMines()
        addTargetEvents()
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
        
        if gameEnded {
            self.performSegue(withIdentifier: "unwindToMSMenu", sender: self)
        } else {
            let alertController = UIAlertController(title: "Are you sure you want to quit?", message: nil, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                self.performSegue(withIdentifier: "unwindToMSMenu", sender: self)
            })
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MSGameViewController: MSDataSource {
    
    func measurementsInitializer(startX: CGFloat, startY: CGFloat, cellSize: CGFloat, cellsPerRow: Int) {
        self.startX = startX
        self.startY = startY
        self.cellSize = cellSize
        self.cellsPerRow = cellsPerRow
    }
    
    func createCell(at x: CGFloat, y: CGFloat, ofSize size: CGFloat, to view: UIView ) {
        let cell = MSCell(frame: CGRect(x: x, y: y, width: size, height: size), visited: false)
        cell.layer.borderWidth = 1
        cell.titleLabel?.font = UIFont.systemFont(ofSize: cellSize)
        cell.setTitleColor(.blue, for: .normal)
        gameEngine.computedCells = (cell, nil)
        //cells.append(cell)
        view.addSubview(cell)
    }
    
    func populateBoard(view: UIView) {
        for _ in 0..<cellsPerRow {
            for _ in 0..<cellsPerRow {
                createCell(at: startX, y: startY, ofSize: cellSize, to: view)
                startX = startX + cellSize
            }
            startX = startX - (cellSize * CGFloat(cellsPerRow))
            startY = startY + cellSize
        }
    }
    
    func plantMines() {
        var i = 0
        
        var mines = 50
        
        switch gameMode {
        case .easy:
            mines = 30
        case .normal:
            mines = 50
        case .hard:
            mines = 70
        }
        
        while(i < mines) {
            let random = arc4random_uniform(UInt32(cellsPerRow * cellsPerRow))

            if(gameEngine.computedCells.cells![Int(random)].titleLabel?.text != "M") {
                gameEngine.computedCells.cells![Int(random)].setTitle("M", for: .selected)
                i += 1
            }
        }
    }
}

extension MSGameViewController: MSDelegate {
    
    func addTargetEvents() {
        for cell in gameEngine.computedCells.cells! {
            cell.addTarget(self, action: #selector(actionOnCell), for: .touchUpInside)
        }
    }
    
    func actionOnCell(sender: MSCell) {
        sender.isSelected = true
        if(sender.titleLabel?.text != "M") {
            //check neighbours
            sender.setTitle(gameEngine.markCell(around: gameEngine.computedCells.cells!.index(of: sender)!), for: .selected)
        } else {
            //game over
            gameEnded = true
            displayGameStatus.text = "Game Over"
            for item in gameEngine.computedCells.cells! {
                item.isUserInteractionEnabled = false
            }
        }
    }
}


