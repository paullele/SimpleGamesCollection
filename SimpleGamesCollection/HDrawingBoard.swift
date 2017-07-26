//
//  ForestOfTheHanged.swift
//  Hang
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

@IBDesignable
class HDrawingBoard: UIView {
    
    var attempts = 0
        
    private enum Legs {
        case Left
        case Right
    }
    
    private enum Arms {
        case Left
        case Right
    }
    
    private func drawHead() {
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2 + 25, y: self.frame.height/2 - 80), radius: 20, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        UIColor.black.set()
        path.lineWidth = 3
        
        path.stroke()
    }
    
    private func drawTorso() {
        
        let path = UIBezierPath()
        UIColor.black.set()
        path.lineWidth = 3
        
        path.move(to: CGPoint(x: self.frame.width/2 + 25, y: self.frame.height/2 - 60))
        path.addLine(to: CGPoint(x: self.frame.width/2 + 25, y: self.frame.height/2 + 20))
        
        path.close()
        path.stroke()
    }
    
    private func drawArms(number: Arms, startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        
        let path = UIBezierPath()
        
        UIColor.black.set()
        path.lineWidth = 3
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        path.close()
        path.stroke()
    }
    
    private func drawLegs(number: Legs, startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat) {
        
        let path = UIBezierPath()
        
        UIColor.black.set()
        path.lineWidth = 3
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        path.close()
        path.stroke()
    }

    private func drawTheHang() {
        
        let path = UIBezierPath()
        UIColor.black.set()
        path.lineWidth = 3
        
        path.move(to: CGPoint(x: self.frame.width/2 - 75, y: self.frame.height/2 - 150))
        path.addLine(to: CGPoint(x: self.frame.width/2 - 75, y: self.frame.height/2 + 150))
        
        path.close()
        path.stroke()
        
        path.move(to: CGPoint(x: self.frame.width/2 - 100, y: self.frame.height/2 + 150))
        path.addLine(to: CGPoint(x: self.frame.width/2 - 50, y: self.frame.height/2 + 150))
        
        path.close()
        path.stroke()
        
        path.move(to: CGPoint(x: self.frame.width/2 - 75, y: self.frame.height/2 - 150))
        path.addLine(to: CGPoint(x: self.frame.width/2 + 75, y: self.frame.height/2 - 150))
        
        path.close()
        path.stroke()
        
        path.move(to: CGPoint(x: self.frame.width/2 + 25, y: self.frame.height/2 - 150))
        path.addLine(to: CGPoint(x: self.frame.width/2 + 25, y: self.frame.height/2 - 100))
        
        path.close()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        
        drawTheHang()
        
        switch attempts {
            
        case 1:
            drawHead()
            
        case 2:
            drawHead()
            drawTorso()
            
        case 3:
            drawHead()
            drawTorso()
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 20)
            
        case 4:
            drawHead()
            drawTorso()
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 20)
            drawArms(number: .Right, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 45, endY: self.frame.height/2 + 20)
            
        case 5:
            drawHead()
            drawTorso()
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 20)
            drawArms(number: .Right, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 45, endY: self.frame.height/2 + 20)
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 + 20, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 100)
            
        case 6:
            drawHead()
            drawTorso()
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 20)
            drawArms(number: .Right, startX: self.frame.width/2 + 25, startY: self.frame.height/2 - 40, endX: self.frame.width/2 + 45, endY: self.frame.height/2 + 20)
            drawArms(number: .Left, startX: self.frame.width/2 + 25, startY: self.frame.height/2 + 20, endX: self.frame.width/2 + 5, endY: self.frame.height/2 + 100)
            drawArms(number: .Right, startX: self.frame.width/2 + 25, startY: self.frame.height/2 + 20, endX: self.frame.width/2 + 45, endY: self.frame.height/2 + 100)
            
        default: break
            
        }
    }
}








