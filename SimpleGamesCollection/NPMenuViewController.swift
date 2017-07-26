//
//  MenuViewController.swift
//  NumbersPuzzle
//
//  Created by apple on 19/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class NPMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Easy" {
            if let gameViewControler = segue.destination as? NPGameViewController {
                gameViewControler.gridSize = 3
                gameViewControler.bound = 8
                gameViewControler.pWidth = 100
                gameViewControler.pHeight = 100
            }
        } else if segue.identifier == "Medium" {
            if let gameViewControler = segue.destination as? NPGameViewController {
                gameViewControler.gridSize = 4
                gameViewControler.bound = 15
                gameViewControler.pWidth = 90
                gameViewControler.pHeight = 90
            }
        } else if segue.identifier == "Hard" {
            if let gameViewControler = segue.destination as? NPGameViewController {
                gameViewControler.gridSize = 5
                gameViewControler.bound = 24
                gameViewControler.pWidth = 75
                gameViewControler.pHeight = 75
            }
        }
    }
    
    @IBAction func unwindToNPMenu(segue: UIStoryboardSegue) {}

}
