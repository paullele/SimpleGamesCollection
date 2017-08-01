//
//  DrawingBoard.swift
//  Practice
//
//  Created by apple on 20/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TTTDrawingBoard: UIView {

    //Mark Draw the table
    
    private enum Row {
        case One
        case Two
    }
    
    private enum Column {
        case One
        case Two
    }
    
    private var cellSize: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func pathForRow(number: Row, startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        path.close()
        UIColor.black.set()
        path.lineWidth = 3
        
        return path
    }
    
    private func pathForColumn(number: Column, startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        path.close()
        UIColor.black.set()
        path.lineWidth = 3
        
        return path
    }
    
    //Mark Draw win line
    //needs to be implemented
    //call setNeedsDisplay() on this view
    var startX: CGFloat = 0
    var startY: CGFloat = 0
    var endX: CGFloat = 0
    var endY: CGFloat = 0
    
    func drawWinLine(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: startX , y: startY))
        
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        path.close()
        UIColor.blue.set()
        path.lineWidth = 3
        return path
    }
    
    override func draw(_ rect: CGRect) {
        
        cellSize = CGFloat((Int(frame.width) - (Int(frame.width) % 100))/Int(3))
        
        pathForRow(number: .One, startX: self.frame.width/2 - cellSize/2, startY: self.frame.height/2 - (cellSize + cellSize/2), endX: self.frame.width/2 - cellSize/2, endY: self.frame.height/2 + (cellSize + cellSize/2)).stroke()
        pathForRow(number: .Two, startX: self.frame.width/2 + cellSize/2, startY: self.frame.height/2 - (cellSize + cellSize/2), endX: self.frame.width/2 + cellSize/2, endY: self.frame.height/2 + (cellSize + cellSize/2)).stroke()
        pathForColumn(number: .One, startX: self.frame.width/2 - (cellSize + cellSize/2), startY: self.frame.height/2 - cellSize/2, endX: self.frame.width/2 + (cellSize + cellSize/2), endY: self.frame.height/2 - cellSize/2).stroke()
        pathForColumn(number: .Two, startX: self.frame.width/2 - (cellSize + cellSize/2), startY: self.frame.height/2 + cellSize/2, endX: self.frame.width/2 + (cellSize + cellSize/2), endY: self.frame.height/2 + cellSize/2).stroke()
                
        drawWinLine(startX: startX, startY: startY, endX: endX, endY: endY).stroke()
    }
}
