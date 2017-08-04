//
//  ViewController.swift
//  21Sticks
//
//  Created by apple on 20/11/2016.
//  Copyright © 2016 apple. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TOGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var sticksLeft: UILabel!
    @IBOutlet weak var displayMessage: UITextView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    private var gameEngine: TOGameEngine?
    var computerGoesFirst = false
    var playersTurn = true;
    
    var singlePlayer = true
    var appDelegate: AppDelegate!
    var mp_Name: String?
    
    var connected = false
    
    fileprivate var gameEnded = false
    
    private var numberOfSticks: Int = 21 {
        didSet {
            updateSticksLeft(with: numberOfSticks)
        }
    }
    
    func handleNewGame() {
        
        numberOfSticks = 21
        
        let messageDict = ["newGame" : "New Game"]
        var messageData: Data? = nil
        
        do {
            messageData = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
        } catch {
            print("Serialization failed")
        }
        
        if messageData != nil {
            do {
                try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
            } catch {
                handleUnwindToMenu()
            }
        }
    }
    
    func connectWithPeers() {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBroser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if singlePlayer {
            
            gameEngine = TOGameEngine()
            
            let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleUnwindToMenu))
            self.navigationItem.leftBarButtonItem = backButton
            
            managePlayersButtons()
            
            if computerGoesFirst {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.computerTakesSticks()
                })
            }
        } else {
            //multiplayer 
            
            mp_Name = UIDevice.current.name
            print(mp_Name!)
            
            let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleNewGame))
            self.navigationItem.leftBarButtonItem = backButton
            
            let connectButton = UIBarButtonItem(title: "Connect", style: .plain, target: self, action: #selector(connectWithPeers))
            self.navigationItem.rightBarButtonItem = connectButton
            
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mpcHandler.setupPeerWithDisplay(name: UIDevice.current.name)
            appDelegate.mpcHandler.setuptSession()
            appDelegate.mpcHandler.advertiseSelf(advertise: true)
            
            NotificationCenter.default.addObserver(self, selector: #selector(peerChangedState), name: Notification.Name("MPC_DidChangeStateNotification"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedData), name: Notification.Name("MPC_DidReceiveDataNotification"), object: nil)
        }
    }
    
    func peerChangedState(withNotification notification: Notification) {
        let userInfo = notification.userInfo!
        let state = userInfo["state"] as! Int
        
        if state == MCSessionState.connected.rawValue {
            self.navigationItem.title = "Connected"
            connected = true
        } else if state == MCSessionState.notConnected.rawValue {
            self.navigationItem.title = "Not Connected"
            connected = false
        }
    }
    
    func handleReceivedData(withNotification notification: Notification) {
        let userInfo = notification.userInfo!
        let receivedData: Data = userInfo["data"] as! Data
        
        let message: [String : Any] = try! JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as! [String : Any]
        
        let senderPeerId = userInfo["peerID"] as! MCPeerID
        let senderDisplayName = senderPeerId.displayName
        
        if message["newGame"] as? String == "New Game" {
            let alert = UIAlertController(title: "21 sticks", message: "\(senderDisplayName) wants to start a new game", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self]
                action in self.numberOfSticks = 21
            })
            
            let noAction = UIAlertAction(title: "Nope", style: .default, handler: { [unowned self]
                action in
                
                self.appDelegate.mpcHandler.session.disconnect()
                self.appDelegate.mpcHandler.advertiseSelf(advertise: false)
                self.handleUnwindToMenu()
            })
            
            alert.addAction(okAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let takenNumber: Int? = message["takenNumber"] as? Int
            let opponentName: String? = message["player"] as? String
            
            if takenNumber != nil && opponentName != nil {
                displayMessage.text = "\(opponentName!) takes \(takenNumber!)"
                numberOfSticks -= takenNumber!
                
                if numberOfSticks == 0 {
                    //you win
                    handleEndGame(withMessage: "You won!")
                }
            }
        }
    }
    
    func handleEndGame(withMessage message: String) {
        let alert = UIAlertController(title: "21 sticks", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self]
            action in
            if self.singlePlayer {
                self.handleUnwindToMenu()
            } else {
                self.displayMessage.text = " "
                self.numberOfSticks = 21
            }
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    
    func updateSticksLeft(with number: Int) {
        sticksLeft.text = String(number)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (navigationController?.viewControllers.count)! > 1 {
            handleUnwindToMenu()
        }
        return false
    }
    
    private func managePlayersButtons() {
        
        if playersTurn {
            button1.isEnabled = true
            button2.isEnabled = true
        } else {
            button1.isEnabled = false
            button2.isEnabled = false
        }
    }
    
    
    @IBAction func takeSticks(_ sender: UIButton) {
        
        let takenNumber = sender.tag
        
        self.displayMessage.text = "You took \(sender.tag)"
        numberOfSticks -= takenNumber
        
        if singlePlayer {
            if takenNumber == 1 {
                displayMessage.text = "Player takes 1 stick"
            } else {
                displayMessage.text = "Player takes 2 sticks"
            }
            
            if numberOfSticks <= 0 {
                displayMessage.text = "Computer wins"
                gameEnded = true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.computerTakesSticks()
                })
            }
            
            playersTurn = false
            managePlayersButtons()
        } else {
            
            if numberOfSticks == 0 {
                //you lost
                handleEndGame(withMessage: "You lost :(")
            }
            
            //send data
            let messageDict = ["takenNumber" : takenNumber, "player": mp_Name!] as [String : Any]
            var messageData: Data? = nil
            
            do {
                messageData = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
            } catch {
                print("Serialization failed")
            }
            
            if messageData != nil {
                do {
                    try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
                } catch {
                    print("Sending data failed")
                }
            }
        }
    }
    
    
    func handleUnwindToMenu() {
        
        if gameEnded {
            performSegue(withIdentifier: "unwindToTOMenu", sender: UIButton())
        } else {
            let alert = UIAlertController(title: "Are you sure you want to start a new game?", message: nil, preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
                action in self.performSegue(withIdentifier: "unwindToTOMenu", sender: nil)
            })
            
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    //to something to move this to engine
    func computerTakesSticks() {
        
        let computerTakesSticks = gameEngine!.takeSticks(numberOfSticks)

        numberOfSticks -= computerTakesSticks
        
        if computerTakesSticks == 1 {
            displayMessage.text = "Computer takes 1 stick"
        } else {
            displayMessage.text = "Computer takes 2 sticks"
        }
        
        if numberOfSticks <= 0 {
            gameEnded = true
            displayMessage.text = "Player wins"
            playersTurn = false
            managePlayersButtons()
        }
        
        playersTurn = true
        managePlayersButtons()
    }
}

extension TOGameViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

