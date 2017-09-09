//
//  MSGameEngine.swift
//  SimpleGamesCollection
//
//  Created by apple on 26/07/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import Foundation
import UIKit

class MSGameEngine {
    
    private var cellsPerRow: Int!
    private var cells = [MSCell]()
    
    var computedCellsPerRow: Int {
        get {
            return cellsPerRow
        }
        
        set (newValue) {
            cellsPerRow = newValue
        }
    }
    
    var computedCells: (cell: MSCell?, cells: [MSCell]?) {
        get {
            return (nil, cells)
        }
        
        set (newValue) {
            cells.append(newValue.cell!)
        }
    }
    
    func markCell(around position: Int) -> String {
        var counter = 0
        
        cells[position].visited = true
        cells[position].isUserInteractionEnabled = false
        
        if (position - cellsPerRow > 0) {
            cells[position - cellsPerRow].isSelected = true
            cells[position - cellsPerRow].isUserInteractionEnabled = false
            if(cells[position - cellsPerRow].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position - cellsPerRow].isSelected = false
        }
        
        if(position + cellsPerRow < cellsPerRow * cellsPerRow) {
            cells[position + cellsPerRow].isSelected = true
            cells[position + cellsPerRow].isUserInteractionEnabled = false
            if(cells[position + cellsPerRow].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position + cellsPerRow].isSelected = false
        }
        
        if(position - 1 >= 0 && position % cellsPerRow != 0) {
            cells[position - 1].isSelected = true
            cells[position - 1].isUserInteractionEnabled = false
            if(cells[position - 1].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position - 1].isSelected = false
        }
        
        if(position + 1 < cellsPerRow * cellsPerRow && (position + 1) % cellsPerRow != 0) {
            cells[position + 1].isSelected = true
            cells[position + 1].isUserInteractionEnabled = false
            if(cells[position + 1].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position + 1].isSelected = false
        }
        
        //diagonals
        if(position - (cellsPerRow + 1) >= 0 && position % cellsPerRow != 0) {
            cells[position - (cellsPerRow + 1)].isSelected = true
            cells[position - (cellsPerRow + 1)].isUserInteractionEnabled = false
            if(cells[position - (cellsPerRow + 1)].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position - (cellsPerRow + 1)].isSelected = false
        }
        
        if(position - (cellsPerRow - 1) > 0 && (position + 1) % cellsPerRow != 0) {
            cells[position - (cellsPerRow - 1)].isSelected = true
            cells[position - (cellsPerRow - 1)].isUserInteractionEnabled = false
            if(cells[position - (cellsPerRow - 1)].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position - (cellsPerRow - 1)].isSelected = false
        }
        
        if(position + (cellsPerRow + 1) < cellsPerRow * cellsPerRow && (position + 1) % cellsPerRow != 0) {
            cells[position + (cellsPerRow + 1)].isSelected = true
            cells[position + (cellsPerRow + 1)].isUserInteractionEnabled = false
            if(cells[position + (cellsPerRow + 1)].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position + (cellsPerRow + 1)].isSelected = false
        }
        
        if (position + (cellsPerRow - 1) < cellsPerRow * cellsPerRow && position % cellsPerRow != 0) {
            cells[position + (cellsPerRow - 1)].isSelected = true
            cells[position + (cellsPerRow - 1)].isUserInteractionEnabled = false
            if(cells[position + (cellsPerRow - 1)].titleLabel?.text == "M") {
                counter += 1
            }
            cells[position + (cellsPerRow - 1)].isSelected = false
        }
        
        
        //check the neighbours
        if (position - cellsPerRow > 0) {
            let title = checkNeighbours(of: position - cellsPerRow)
            if(title == "0" && cells[position - cellsPerRow].visited == false) {
                cells[position - cellsPerRow].setTitle(markCell(around: position - cellsPerRow), for: .selected)
            } else {
                cells[position - cellsPerRow].setTitle(title, for: .selected)
            }
        }
        
        if(position + cellsPerRow < cellsPerRow * cellsPerRow) {
            let title = checkNeighbours(of: position + cellsPerRow)
            if(title == "0" && cells[position + cellsPerRow].visited == false) {
                cells[position + cellsPerRow].setTitle(markCell(around: position + cellsPerRow), for: .selected)
            } else {
                cells[position + cellsPerRow].setTitle(title, for: .selected)
            }
        }
        
        if(position - 1 >= 0 && position % cellsPerRow != 0) {
            let title = checkNeighbours(of: position - 1)
            if(title == "0" && cells[position - 1].visited == false) {
                cells[position - 1].setTitle(markCell(around: position - 1), for: .selected)
            } else {
                cells[position - 1].setTitle(title, for: .selected)
            }
        }
        
        if(position + 1 < cellsPerRow * cellsPerRow && (position + 1) % cellsPerRow != 0) {
            let title = checkNeighbours(of: position + 1)
            if(title == "0" && cells[position + 1].visited == false) {
                cells[position + 1].setTitle(markCell(around: position + 1), for: .selected)
            } else {
                cells[position + 1].setTitle(title, for: .selected)
            }
        }
        
        if(position - (cellsPerRow + 1) >= 0 && position % cellsPerRow != 0) {
            let title = checkNeighbours(of: position - (cellsPerRow + 1))
            if(title == "0" && cells[position - (cellsPerRow + 1)].visited == false) {
                cells[position - (cellsPerRow + 1)].setTitle(markCell(around: position - (cellsPerRow + 1)), for: .selected)
            } else {
                cells[position - (cellsPerRow + 1)].setTitle(title, for: .selected)
            }
        }
        
        if(position - (cellsPerRow - 1) > 0 && (position + 1) % cellsPerRow != 0) {
            let title = checkNeighbours(of: position - (cellsPerRow - 1))
            if(title == "0" && cells[position - (cellsPerRow - 1)].visited == false) {
                cells[position - (cellsPerRow - 1)].setTitle(markCell(around: position - (cellsPerRow - 1)), for: .selected)
            } else {
                cells[position - (cellsPerRow - 1)].setTitle(title, for: .selected)
            }
        }
        
        if(position + (cellsPerRow + 1) < cellsPerRow * cellsPerRow && (position + 1) % cellsPerRow != 0) {
            let title = checkNeighbours(of: position + cellsPerRow + 1)
            if(title == "0" && cells[position + (cellsPerRow + 1)].visited == false) {
                cells[position + cellsPerRow + 1].setTitle(markCell(around: position + cellsPerRow + 1), for: .selected)
            } else {
                cells[position + cellsPerRow + 1].setTitle(title, for: .selected)
            }
        }
        
        if (position + (cellsPerRow - 1) < cellsPerRow * cellsPerRow && position % cellsPerRow != 0) {
            let title = checkNeighbours(of: position + (cellsPerRow - 1))
            if(title == "0" && cells[position + (cellsPerRow - 1)].visited == false) {
                cells[position + (cellsPerRow - 1)].setTitle(markCell(around: position + (cellsPerRow - 1)), for: .selected)
            } else {
                cells[position + (cellsPerRow - 1)].setTitle(title, for: .selected)
            }
        }
        
        return String(counter)
    }
    
    func checkNeighbours(of position: Int) -> String {
        var counter = 0
        
        cells[position].isSelected = true
        
        if(cells[position].titleLabel?.text == "M") {
            return "M"
        }
        
        if (position - cellsPerRow > 0) {
            if(cells[position - cellsPerRow].isSelected == false) {
                cells[position - cellsPerRow].isSelected = true
                if(cells[position - cellsPerRow].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position - cellsPerRow].isSelected = false
            } else {
                if(cells[position - cellsPerRow].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if(position + cellsPerRow < cellsPerRow * cellsPerRow) {
            if(cells[position + cellsPerRow].isSelected == false) {
                cells[position + cellsPerRow].isSelected = true
                if(cells[position + cellsPerRow].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position + cellsPerRow].isSelected = false
            } else {
                if(cells[position + cellsPerRow].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if(position - 1 >= 0 && position % cellsPerRow != 0) {
            if(cells[position - 1].isSelected == false) {
                if(cells[position - 1].titleLabel?.text == "M") {
                    counter += 1
                }
            } else {
                if(cells[position - 1].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if(position + 1 < cellsPerRow * cellsPerRow && (position + 1) % cellsPerRow != 0) {
            if(cells[position + 1].isSelected == false) {
                cells[position + 1].isSelected = true
                if(cells[position + 1].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position + 1].isSelected = false
            } else {
                if(cells[position + 1].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        //diagonals
        if(position - (cellsPerRow + 1) >= 0) {
            if(cells[position - (cellsPerRow + 1)].isSelected == false) {
                cells[position - (cellsPerRow + 1)].isSelected = true
                if(cells[position - (cellsPerRow + 1)].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position - (cellsPerRow + 1)].isSelected = false
            } else {
                if(cells[position - (cellsPerRow + 1)].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if(position - (cellsPerRow - 1) > 0 && position % cellsPerRow != 0) {
            if(cells[position - (cellsPerRow - 1)].isSelected == false) {
                cells[position - (cellsPerRow - 1)].isSelected = true
                if(cells[position - (cellsPerRow - 1)].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position - (cellsPerRow - 1)].isSelected = false
            } else {
                if(cells[position - (cellsPerRow - 1)].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if(position + (cellsPerRow + 1) < cellsPerRow * cellsPerRow) {
            if(cells[position + (cellsPerRow + 1)].isSelected == false) {
                cells[position + (cellsPerRow + 1)].isSelected = true
                if(cells[position + (cellsPerRow + 1)].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position + (cellsPerRow + 1)].isSelected = false
            } else {
                if(cells[position + (cellsPerRow + 1)].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        if (position + (cellsPerRow - 1) < cellsPerRow * cellsPerRow) {
            if(cells[position + (cellsPerRow - 1)].isSelected == false) {
                cells[position + (cellsPerRow - 1)].isSelected = true
                if(cells[position + (cellsPerRow - 1)].titleLabel?.text == "M") {
                    counter += 1
                }
                cells[position + (cellsPerRow - 1)].isSelected = false
            } else {
                if(cells[position + (cellsPerRow - 1)].titleLabel?.text == "M") {
                    counter += 1
                }
            }
        }
        
        return String(counter)
    }
}
