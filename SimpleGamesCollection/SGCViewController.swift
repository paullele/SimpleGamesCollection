//
//  ViewController.swift
//  SimpleGamesCollection
//
//  Created by apple on 21/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class SGCViewController: UIViewController {
    
    
    @IBOutlet weak var gameSelectionStack: UIStackView!
    
    @IBAction func playTicTacToe(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "tttMenu") as! TTTMenuViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func playMinesweeper(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "msMenu") as! MSMenuViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func playNumbersPuzzle(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "npMenu") as! NPMenuViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

    @IBAction func play21Sticks(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "toMenu") as! TOMenuViewControlelr
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func playHang(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "hGame") as! HGameViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func playGuessTheNumber(_ sender: UIButton) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gnMenu") as! GNMenuViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMasterMenu(segue: UIStoryboardSegue){}
}

