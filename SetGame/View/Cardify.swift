//
//  Cardify.swift
//  Memorize
//
//  Created by Gavin Butler on 07-12-2020.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    //var rotation: Double
    
    var isFaceUp: Bool
    var isSelected: Bool
    var colour: ShapeColour
    
//    var animatableData: Double {
//        get { rotation }
//        set { rotation = newValue }
//    }
    
//    init(isFaceUp: Bool) {
//        rotation = isFaceUp ? 0 : 180
//    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: isSelected ? 5 : 1)
                        
                    content
                    //.rotation3DEffect(Angle.degrees(180), axis: (x: 0, y: 1, z: 0))
                        
                }
                
//                .rotationEffect(.degrees(isFaceUp ? 270 : 0))
//                .animation(Animation.linear(duration: 3).delay(0).repeatForever())
                
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Theme.colourFor(colour))
                    //.transition(.opacity)
                    //.animation(.linear(duration: 3))
            }
        }
        .rotation3DEffect(Angle.degrees(isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        //.animation(isFaceUp ? Animation.linear(duration: 1).delay(0).repeatForever() : .default)
        
        
    }
    
    //MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    
}

extension View {
    func cardify(isFaceUp: Bool, isSelected: Bool, colour: ShapeColour) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected, colour: colour))
    }
}

