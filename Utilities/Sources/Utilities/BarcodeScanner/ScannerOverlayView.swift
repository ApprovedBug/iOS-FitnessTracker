//
//  ScannerOverlayView.swift
//  Utilities
//
//  Created by Jack Moseley on 12/11/2024.
//

import Foundation
import UIKit

class ScannerOverlayView: UIView {
    private let lineLength: CGFloat = 30.0
    private let lineThickness: CGFloat = 4.0
    private let cornerColor: UIColor = .lightGray // Color of the corner lines
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(lineThickness)
        context?.setStrokeColor(cornerColor.cgColor)
        
        // Top left corner
        drawCorner(context: context, startPoint: CGPoint(x: rect.minX, y: rect.minY), horizontal: true)
        drawCorner(context: context, startPoint: CGPoint(x: rect.minX, y: rect.minY), horizontal: false)
        
        // Top right corner
        drawCorner(context: context, startPoint: CGPoint(x: rect.maxX - lineLength, y: rect.minY), horizontal: true)
        drawCorner(context: context, startPoint: CGPoint(x: rect.maxX, y: rect.minY), horizontal: false)
        
        // Bottom left corner
        drawCorner(context: context, startPoint: CGPoint(x: rect.minX, y: rect.maxY - lineLength), horizontal: false)
        drawCorner(context: context, startPoint: CGPoint(x: rect.minX, y: rect.maxY), horizontal: true)
        
        // Bottom right corner
        drawCorner(context: context, startPoint: CGPoint(x: rect.maxX - lineLength, y: rect.maxY), horizontal: true)
        drawCorner(context: context, startPoint: CGPoint(x: rect.maxX, y: rect.maxY - lineLength), horizontal: false)
        
        context?.strokePath()
    }
    
    private func drawCorner(context: CGContext?, startPoint: CGPoint, horizontal: Bool) {
        context?.move(to: startPoint)
        let endPoint: CGPoint
        if horizontal {
            endPoint = CGPoint(x: startPoint.x + lineLength, y: startPoint.y)
        } else {
            endPoint = CGPoint(x: startPoint.x, y: startPoint.y + lineLength)
        }
        context?.addLine(to: endPoint)
    }
}

