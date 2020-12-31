//
//  SetCapsule.swift
//  SetGame
//
//  Created by Gavin Butler on 23-12-2020.
//

import SwiftUI

///  Could probably have used SwiftUI's capsule view, but using Shape to be consistent

struct SetCapsule: Shape {

    func path(in rect: CGRect) -> Path {
        
        let height = rect.height/2
        let midY = rect.midY
        
        var p = Path()
        
        p.addArc(center: CGPoint(x: height, y: midY), radius: height, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)  //Bottom left to top left
        p.addLine(to: CGPoint(x: rect.maxX-height, y: midY - height))   //Top right
        p.addArc(center: CGPoint(x: rect.maxX-height, y: midY), radius: height, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false) //Top right to bottom right
        p.closeSubpath()    //To bottom left
        
        return p
    }
}

