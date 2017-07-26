//
//  MenuViewController.swift
//  Minesweeper
//
//  Created by apple on 12/06/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

enum GameMode {
    case easy
    case normal
    case hard
}

var gameMode = GameMode.normal

class MSMenuViewController: UIViewController {
    
    
    @IBOutlet var gameModeButtons: [UIButton]!
    
    @IBAction func unwindToMSMenu(segue: UIStoryboardSegue){}

    @IBAction func onStartGame(_ sender: UIButton) {
        segueToGame()
    }
    
    @IBAction func onEasy(_ sender: UIButton) {
        let index = gameModeButtons.index(of: sender)
        handleSelection(for: gameModeButtons[index!])
        gameMode = GameMode.easy
    }
    
    @IBAction func onNormal(_ sender: UIButton) {
        let index = gameModeButtons.index(of: sender)
        handleSelection(for: gameModeButtons[index!])
        gameMode = GameMode.normal
    }
    
    @IBAction func onHard(_ sender: UIButton) {
        let index = gameModeButtons.index(of: sender)
        handleSelection(for: gameModeButtons[index!])
        gameMode = GameMode.hard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func handleSelection(for sender: UIButton) {
        for button in gameModeButtons {
            if(button.isSelected == true) {
                button.isSelected = false
            }
        }
        sender.isSelected = true
    }
    
    private func segueToGame() {
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "msGameViewController") as! MSGameViewController
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
