//
//  ForestOfTheHanged.swift
//  Hang
//
//  Created by apple on 31/01/2017.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

/*
 HEIGHT
 20px aprox 5%
 10px aprox 2.5%
 5px apox 1.25%
 
 HEIGHT
 20px aprox 3%
 10px aprox 1.5%
 5px apox 0.75%
 */

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawHead() {
        
        let radius = self.frame.width * 5 / 100
        let x = self.frame.width * 6.25 / 100
        let y = self.frame.height * 12 / 100
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 - y), radius: radius, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        UIColor.black.set()
        path.lineWidth = 3
        
        path.stroke()
    }
    
    private func drawTorso() {
        
        let path = UIBezierPath()
        UIColor.black.set()
        path.lineWidth = 3
        
        let x = self.frame.width * 6.25 / 100
        var y = self.frame.height * 9 / 100
        
        path.move(to: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 - y))
        
        y = self.frame.height * 3 / 100
        
        path.addLine(to: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 + y))
        
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
        
        var x = self.frame.width * 18.75 / 100
        var y = self.frame.height * 22.5 / 100
        
        path.move(to: CGPoint(x: self.frame.width/2 - x, y: self.frame.height/2 - y))
        path.addLine(to: CGPoint(x: self.frame.width/2 - x, y: self.frame.height/2 + y))
        
        path.close()
        path.stroke()
        
        x = self.frame.width * 25 / 100
        
        path.move(to: CGPoint(x: self.frame.width/2 - x, y: self.frame.height/2 + y))
        
        x = self.frame.width * 12.50 / 100
        
        path.addLine(to: CGPoint(x: self.frame.width/2 - x, y: self.frame.height/2 + y))
        
        path.close()
        path.stroke()
        
        x = self.frame.width * 18.75 / 100
        
        path.move(to: CGPoint(x: self.frame.width/2 - x, y: self.frame.height/2 - y))
        path.addLine(to: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 - y))
        
        path.close()
        path.stroke()
        
        x = self.frame.width * 6.25 / 100
        
        path.move(to: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 - y))
        
        y = self.frame.height * 15 / 100
        
        path.addLine(to: CGPoint(x: self.frame.width/2 + x, y: self.frame.height/2 - y))
        
        path.close()
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        
        drawTheHang()
        
        var startX: CGFloat = 0
        var startY: CGFloat = 0
        
        var endX: CGFloat = 0
        var endY: CGFloat = 0
                
        switch attempts {
            
        case 1:
            drawHead()
            
        case 2:
            drawHead()
            drawTorso()
            
        case 3:
            drawHead()
            drawTorso()
            
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 6 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 3 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
        case 4:
            drawHead()
            drawTorso()
            
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 6 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 3 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            endX = self.frame.width * 11.25 / 100
            
            drawArms(number: .Right, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
        case 5:
            drawHead()
            drawTorso()
            
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 6 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 3 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            endX = self.frame.width * 11.25 / 100
            
            drawArms(number: .Right, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            //legs
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 3 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 15 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 + startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
        case 6:
            drawHead()
            drawTorso()
            
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 6 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 3 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            endX = self.frame.width * 11.25 / 100
            
            drawArms(number: .Right, startX: self.frame.width/2 + startX, startY: self.frame.height/2 - startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            
            //legs
            startX = self.frame.width * 6.25 / 100
            startY = self.frame.height * 3 / 100
            
            endX = self.frame.width * 1.25 / 100
            endY = self.frame.height * 15 / 100
            
            drawArms(number: .Left, startX: self.frame.width/2 + startX, startY: self.frame.height/2 + startY, endX: self.frame.width/2 + endX, endY: self.frame.height/2 + endY)
            
            endX = self.frame.width * 11.25 / 100
            
            drawArms(number: .Right, startX: self.frame.width/2 + startX, startY: self.frame.height/2 + startY, endX: self.frame.width/2 + 45, endY: self.frame.height/2 + endY)
            
        default: break
            
        }
    }
}








