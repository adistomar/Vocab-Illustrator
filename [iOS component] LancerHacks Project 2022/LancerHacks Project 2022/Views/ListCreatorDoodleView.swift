//
//  ListCreatorDoodleView.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class ListCreatorDoodleView: UIView {
    
    //Credit to: https://betterprogramming.pub/drawing-in-an-uiview-4bc754483242

    var lineArray: [[CGPoint]] = [[CGPoint]]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let firstPoint = touch.location(in: self)

        lineArray.append([CGPoint]())
        lineArray[lineArray.count - 1].append(firstPoint)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        lineArray[lineArray.count - 1].append(currentPoint)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        draw(inContext: context)
    }
    
    func draw(inContext context: CGContext) {
        context.setLineWidth(5)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineCap(.round)

        for line in lineArray {
            
            guard let firstPoint = line.first else { continue }
            context.beginPath()
            context.move(to: firstPoint)
            
            for point in line.dropFirst() {
                context.addLine(to: point)
            }
            context.strokePath()
        }
    }
    
    func resetDrawing() {
        lineArray = []
        setNeedsDisplay()
    }
    
    func exportAsImage() -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        draw(inContext: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

}

