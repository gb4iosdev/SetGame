//
//  Squiggle.swift
//  SetGame
//
//  Created by Gavin Butler on 22-12-2020.
//

import SwiftUI
///  Draws the squiggle captured in the Affinity Designer file squiggle.afdesign in the assets directory
///  Affinity designer provides a visual of the control point locations for each main point on the curve
///  and using a grid allows for these control point locations to be quantified per the constants below.
///  Note use of the (1-number) and +/- height below, which leverages the semi-symmetrical nature of the shape.

struct Squiggle: Shape {

    func path(in rect: CGRect) -> Path {
        
        let width = rect.width      //Width of the rectangle passed in (for typing convenience only)
        let height = rect.height/2   //Shape is symmetrical when flipped twice, so easier to express height as half the overall rectangle height.
        let midY = rect.midY        //(for typing convenience only)
        
        var p = Path()
        
        p.move(to: CGPoint(x: width*0.015, y: midY))
        p.addCurve(to: CGPoint(x: width*0.2, y: midY+height*0.65), control1: CGPoint(x: width*0.05, y: midY+height*0.93), control2: CGPoint(x: width*0.11, y: midY+height*1.03))
        p.addCurve(to: CGPoint(x: width*0.575, y: midY+height*0.75), control1: CGPoint(x: width*0.32, y: midY+height*0.34), control2: CGPoint(x: width*0.45, y: midY+height*0.5))
        p.addCurve(to: CGPoint(x: width*0.94, y: midY+height*0.62), control1: CGPoint(x: width*0.75, y: midY+height*1.03), control2: CGPoint(x: width*0.875, y: midY+height*0.94))
        p.addCurve(to: CGPoint(x: width*0.985, y: midY), control1: CGPoint(x: width*0.965, y: midY+height*0.55), control2: CGPoint(x: width*0.98, y: midY+height*0.34))

        //Now mirror on the horizontal axis:
        p.addCurve(to: CGPoint(x: width*(1-0.2), y: midY-height*0.65), control1: CGPoint(x: width*(1-0.05), y: midY-height*0.93), control2: CGPoint(x: width*(1-0.11), y: midY-height*1.03))
        p.addCurve(to: CGPoint(x: width*(1-0.575), y: midY-height*0.75), control1: CGPoint(x: width*(1-0.32), y: midY-height*0.34), control2: CGPoint(x: width*(1-0.45), y: midY-height*0.5))
        p.addCurve(to: CGPoint(x: width*(1-0.94), y: midY-height*0.62), control1: CGPoint(x: width*(1-0.75), y: midY-height*1.03), control2: CGPoint(x: width*(1-0.875), y: midY-height*0.94))
        p.addCurve(to: CGPoint(x: width*(1-0.985), y: midY), control1: CGPoint(x: width*(1-0.965), y: midY-height*0.55), control2: CGPoint(x: width*(1-0.98), y: midY-height*0.34))
        p.closeSubpath()
        
        return p
    }
}

