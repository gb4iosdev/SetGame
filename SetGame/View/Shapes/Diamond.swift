//
//  Diamond.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

struct Diamond: Shape {
    
    let rectHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        
        var p = Path()
        
        p.move(to: CGPoint(x: rect.midX, y: rect.midY - rectHeight/2))      //Top middle
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))                  //Left middle
        p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rectHeight/2))   //Bottom middle
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))                  //Right middle
        p.closeSubpath()
        
        return p
    }
}

