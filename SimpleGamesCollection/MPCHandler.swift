//
//  MPCHandler.swift
//  SimpleGamesCollection
//
//  Created by apple on 03/08/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MPCHandler: NSObject {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser:MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    
    func setupPeerWithDisplay(name: String) {
        peerID = MCPeerID(displayName: name)
    }
    
    func setuptSession() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
    }
    
    func setupBroser() {
        browser = MCBrowserViewController(serviceType: "my-game", session: session)
    }
    
    func advertiseSelf(advertise: Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
}

extension MPCHandler: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo = ["peerID":peerID, "state":state.rawValue] as [String : Any]
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("MPC_DidChangeStateNotification"), object: nil, userInfo: userInfo)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userData = ["peerID":peerID, "data":data] as [String : Any]
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name("MPC_DidReceiveDataNotification"), object: nil, userInfo: userData)
        }
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        //
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
}
