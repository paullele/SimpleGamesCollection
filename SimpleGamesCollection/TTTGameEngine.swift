//
//  GameEngine.swift
//  Practice
//
//  Created by apple on 22/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

class TTTGameEngine {
    
    func decidePosition(_ fields: [UIButton], _ computerSignature: String, _ playerSignature: String, _ reference: String) -> Bool {
        
        let gridSize = fields.count
        let elementsPerRow = Int(sqrt(Double(gridSize)))
        
        for position in 0..<gridSize {
            
            //check if position is available
            if(fields[position].currentTitle != computerSignature &&
                fields[position].currentTitle != playerSignature) {
                
                //decide on position
                
                var localPosition = position
                var counter = 0
                
                //can go down and search elementsPerRow - 1 references
                while(localPosition + elementsPerRow < gridSize) {
                    localPosition = localPosition + elementsPerRow
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                //if enough references were found
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //can go up
                while(localPosition - elementsPerRow >= 0) {
                    localPosition = localPosition - elementsPerRow
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //reset counter because the line is changing
                counter = 0
                
                //can go left
                while(localPosition - 1 >= 0 && localPosition % elementsPerRow != 0) {
                    localPosition = localPosition - 1
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //can go right
                while(localPosition + 1 < gridSize && (localPosition + 1) % elementsPerRow != 0) {
                    localPosition = localPosition + 1
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //reset counter because the line is changing
                counter = 0
                
                //can go down main diagonal
                while(localPosition + (elementsPerRow + 1) < gridSize && (localPosition + 1) % elementsPerRow != 0) {
                    localPosition = localPosition + (elementsPerRow + 1)
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //can go up main diagonal
                while(localPosition - (elementsPerRow + 1) >= 0 && localPosition % elementsPerRow != 0) {
                    localPosition = localPosition - (elementsPerRow + 1)
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //reset counter because the line is changing
                counter = 0
                
                //can go down secondary diagonal
                while(localPosition + (elementsPerRow - 1) <= (gridSize - elementsPerRow) && localPosition % elementsPerRow != 0) {
                    localPosition = localPosition + (elementsPerRow - 1)
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
                
                //reset local position
                localPosition = position
                
                //can go up secondary diagonal
                while(localPosition - (elementsPerRow - 1) >= elementsPerRow - 1 && (localPosition + 1) % elementsPerRow != 0) {
                    localPosition = localPosition - (elementsPerRow - 1)
                    if(fields[localPosition].currentTitle == reference) {
                        counter += 1
                    }
                }
                
                if(counter == elementsPerRow - 1) {
                    fields[position].setTitle(computerSignature, for: UIControlState())
                    return true
                }
            }
        }
        return false
    }
    
    func searchPosition(_ fields: [UIButton], _ computerSignature: String, _ playerSignature: String) {
        
        //check winning positions
        if !decidePosition(fields, computerSignature, playerSignature, computerSignature) {
            //check defense positions
            if !decidePosition(fields, computerSignature, playerSignature, playerSignature) {
                
                var r: Int?
                repeat {
                    r = Int(arc4random_uniform(9))
                }
                    while(fields[r!].currentTitle == computerSignature ||
                        fields[r!].currentTitle == playerSignature)
                
                fields[r!].setTitle(computerSignature, for: UIControlState())
            }
        }
    }
    
    
    func existsWinner(_ fields: [UIButton], _ reference: String) -> Bool {
        
        //from 0
        if (reference == fields[0].currentTitle &&
            fields[0].currentTitle == fields[1].currentTitle &&
            fields[1].currentTitle == fields[2].currentTitle) {
            
            return true
        }
        else if (reference == fields[0].currentTitle &&
            fields[0].currentTitle == fields[4].currentTitle &&
            fields[4].currentTitle == fields[8].currentTitle) {
            
            return true
        }
        else if (reference == fields[0].currentTitle &&
            fields[0].currentTitle == fields[3].currentTitle &&
            fields[3].currentTitle == fields[6].currentTitle) {
            
            return true
        }
            
            //from 1
        else if (reference == fields[1].currentTitle &&
            fields[1].currentTitle == fields[4].currentTitle &&
            fields[4].currentTitle == fields[7].currentTitle) {
            
            return true
        }
        
        //from 2
        if (reference == fields[2].currentTitle &&
            fields[2].currentTitle == fields[4].currentTitle &&
            fields[4].currentTitle == fields[6].currentTitle) {
            
            return true
        }
        else if (reference == fields[2].currentTitle &&
            fields[2].currentTitle == fields[5].currentTitle &&
            fields[5].currentTitle == fields[8].currentTitle) {
            
            return true
        }
        
        //from 3
        if (reference == fields[3].currentTitle &&
            fields[3].currentTitle == fields[4].currentTitle &&
            fields[4].currentTitle == fields[5].currentTitle) {
            
            return true
        }
        
        //from 6
        if (reference == fields[6].currentTitle &&
            fields[6].currentTitle == fields[7].currentTitle &&
            fields[7].currentTitle == fields[8].currentTitle) {
            
            return true
        }
        return false
    }
}
