//
//  Squiggle.swift
//  SetGame
//
//  Created by Gavin Butler on 22-12-2020. 
//

import SwiftUI

struct Squiggle: Shape {
    
    let rectHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        
        let width = rect.width
        let height = rectHeight
        
        print("rect.height in the path is \(rect.height)")
        
        
        var p = Path()
        
        p.move(to: CGPoint(x: width*0.04, y: height*0.24))
        p.addCurve(to: CGPoint(x: width*0.2, y: height*0.765), control1: CGPoint(x: -width*0.02, y: height*0.49), control2: CGPoint(x: 0, y: height*1.2))
        p.addCurve(to: CGPoint(x: width*0.52, y: height*0.765), control1: CGPoint(x: width*0.3, y: height*0.6), control2: CGPoint(x: width*0.41, y: height*0.6))
        p.addCurve(to: CGPoint(x: width*0.935, y: height*0.76), control1: CGPoint(x: width*0.63, y: height*0.95), control2: CGPoint(x: width*0.83, y: height*1.05))
        p.addCurve(to: CGPoint(x: width*0.84, y: height*0.15), control1: CGPoint(x: width*1.01, y: height*0.6), control2: CGPoint(x: width*1.0, y: -height*0.175))
        p.addCurve(to: CGPoint(x: width*0.47, y: height*0.25), control1: CGPoint(x: width*0.75, y: height*0.25), control2: CGPoint(x: width*0.58, y: height*0.3))
        p.addCurve(to: CGPoint(x: width*0.04, y: height*0.24), control1: CGPoint(x: width*0.31, y: height*0.1), control2: CGPoint(x: width*0.115, y: -height*0.15))
        p.closeSubpath()
        
        return p
    }
}

