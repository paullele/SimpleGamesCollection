//
//  ViewController.swift
//  Practice
//
//  Created by apple on 17/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TTTGameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let gridSize: CGFloat = 3
    let gameEngine = TTTGameEngine()
    
    var gameEnded = false
    var cellSize: CGFloat!
    
    var k: Int = 0
    var cellTag = 0
    var drawingBoard: UIView!
    var container = [UIButton]()
    var startX: CGFloat!
    var startY: CGFloat!
    
    var singlePlayer = true
    
    var currentPlayer: String = "X"
    var connected = false
    var appDelegate: AppDelegate!
    
    var computerSignature: String!
    
    var playerSignature: String!
    
    var computerGoesFirst: Bool?
    
    @objc private func handleUnwindToMenu() {
        
        if !gameEnded {
            
            let controller = UIAlertController(title: "Are you sure you want to start a new game?", message: nil, preferredStyle: .actionSheet)
            
            let yesAction = UIAlertAction(title: "Yes, I'm sure!", style: .destructive, handler: {
                
                [unowned self] action in
                
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
    
    func handleEndGameWith(message: String) {
        
        gameEnded = true
        
        let alert = UIAlertController(title: "Tic Tac Toe", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            [unowned self] action in
            
            if self.singlePlayer {
                self.handleUnwindToMenu()
            } else {
                self.resetField()
            }
        })
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    func searchWinner(withSignature signature: String, andName name: String) -> Bool {
        
        k += 1
        
        if k > 4 {
            if gameEngine.existsWinner(container, signature) {
                handleEndGameWith(message: "\(name) won")
                return true
            } else if k == 9 {
                handleEndGameWith(message: "Tie")
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
        
        //game setup
        
        drawingBoard = TTTDrawingBoard(frame: self.view.frame)
        drawingBoard.backgroundColor = UIColor.white
        
        self.view.addSubview(drawingBoard);
    
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        cellSize = CGFloat((Int(self.view.frame.width) - (Int(self.view.frame.width) % 100))/Int(gridSize))
                
        //set the grid origins
        startX = ((self.view.frame.width/2 - ((cellSize * gridSize) / 2)))
        startY = ((self.view.frame.height/2 - ((cellSize * gridSize) / 2)))
        
        //construct the grid interactive cells
        populateBoard()
        
        //if single player
        
        if singlePlayer {
            
            let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleUnwindToMenu))
            navigationItem.leftBarButtonItem = backButton
            
            if computerGoesFirst! {
                computerSignature = "X"
                playerSignature = "0"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.gameEngine.searchPosition(self.container, self.computerSignature, self.playerSignature)
                    self.k += 1
                })
            }
            else {
                computerSignature = "0"
                playerSignature = "X"
            }
        } else {
            
            //MPC Setup
            
            let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(handleNewGame))
            navigationItem.leftBarButtonItem = backButton
            
            let connectButton = UIBarButtonItem(title: "Connect", style: .plain, target: self, action: #selector(connectWithPeer))
            navigationItem.rightBarButtonItem = connectButton
            
            appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mpcHandler.setupPeerWithDisplay(name: UIDevice.current.name)
            appDelegate.mpcHandler.setuptSession()
            appDelegate.mpcHandler.advertiseSelf(advertise: true)
            
            NotificationCenter.default.addObserver(self, selector: #selector(peerChangedStateWith), name: Notification.Name("MPC_DidChangeStateNotification"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedDataWith), name: Notification.Name("MPC_DidReceiveDataNotification"), object: nil)
        }
    }
    
    func peerChangedStateWith(notification: Notification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        
        if state == MCSessionState.connected.rawValue {
            self.navigationItem.title = "Connected"
            resetField()
            connected = true
        } else if state == MCSessionState.notConnected.rawValue {
            self.navigationItem.title = "Not Connected"
            connected = false
        }
    }
    
    func handleReceivedDataWith(notification: Notification) {
        
        let userInfo = notification.userInfo!
        let receiveData: Data = userInfo["data"] as! Data
        
        let message: [String : Any] = try! JSONSerialization.jsonObject(with: receiveData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
        
        let senderPeerID = userInfo["peerID"] as! MCPeerID
        let senderDisplayName = senderPeerID.displayName
        
        if message["newGame"] as? String == "New Game" {
            let alert = UIAlertController(title: "Tic Tac Toe", message: "\(senderDisplayName) wants to start a new game", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self]
                action in self.resetField()
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
            
            let cell: Int? = message["cell"] as? Int
            let player: String? = message["player"] as? String
            
            if cell != nil && player != nil {
                container[cell!].setTitle(player!, for: .normal)
                container[cell!].isUserInteractionEnabled = false
                
                if !searchWinner(withSignature: "X", andName: "X") {
                    _ = searchWinner(withSignature: "0", andName: "0")
                }
                
                if player == "X" {
                    currentPlayer = "0"
                } else {
                    currentPlayer = "X"
                }
            }
        }
    }
    
    func connectWithPeer() {
        if appDelegate.mpcHandler.session != nil {
            appDelegate.mpcHandler.setupBroser()
            appDelegate.mpcHandler.browser.delegate = self
            self.present(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    func handleNewGame() {
        
        resetField()
        
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
    
    func resetField() {
        
        currentPlayer = "X"
        k = 0
        
        for item in container {
            item.setTitle(" ", for: .normal)
            item.isUserInteractionEnabled = true
        }
    }
}

extension TTTGameViewController: GridGameDelegate {
    
    func actionOnSender(_ sender: AnyObject) {
        
        let sender = sender as! UIButton
        
        //single player
        if singlePlayer {
            
            sender.setTitle(playerSignature, for: .normal)
            sender.isUserInteractionEnabled = false
            
            if !searchWinner(withSignature: playerSignature, andName: "Player") && !gameEnded {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.gameEngine.searchPosition(self.container, self.computerSignature, self.playerSignature)
                    
                    _ = self.searchWinner(withSignature: self.computerSignature, andName: "Computer")
                })
            }
            
        } else {
            //multiplayer
            
            sender.setTitle(currentPlayer, for: .normal)
            sender.isUserInteractionEnabled = false
            
            //send data
            let messageDict = ["cell":container[sender.tag].tag, "player":currentPlayer] as [String : Any] 
            var messageData: Data? = nil
            
            do {
                messageData = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
            } catch {
                //some error
                print("JSONSerialization failed")
            }
            
            if messageData != nil {
                do {
                    try appDelegate.mpcHandler.session.send(messageData!, toPeers: appDelegate.mpcHandler.session.connectedPeers, with: .reliable)
                } catch {
                    //some error
                    print("Sending data failed")
                }
            }
            
            //search for winner
            if connected {
                if !searchWinner(withSignature: "X", andName: "X") {
                    _ = searchWinner(withSignature: "0", andName: "0")
                }
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
        cell.tag = cellTag
        container.append(cell)
        view.addSubview(cell)
    }
    
    func populateBoard() {
        
        for _ in 0 ..< Int(gridSize) {
            for _ in 0 ..< Int(gridSize) {
                createCell(at: startX, y: startY, ofSize: cellSize, to: self.drawingBoard)
                startX = startX + cellSize
                
                cellTag += 1
            }
            
            startX = startX - (cellSize * gridSize)
            startY = startY + cellSize
        }
    }
}

extension TTTGameViewController: MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

