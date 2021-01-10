//
//  Cardify.swift
//  Memorize
//
//  Created by Gavin Butler on 07-12-2020.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    var isSelected: Bool
    var colour: ShapeColour
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool, isSelected: Bool, colour: ShapeColour) {
        rotation = isFaceUp ? 0 : 180
        self.isSelected = isSelected
        self.colour = colour
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                Group {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: isSelected ? 5 : 1)
                    content
                }
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Theme.colourFor(colour))
            }
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    //MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    
}

extension View {
    func cardify(isFaceUp: Bool, isSelected: Bool, colour: ShapeColour) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected, colour: colour))
    }
}

