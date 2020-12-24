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
    
//    var animatableData: Double {
//        get { rotation }
//        set { rotation = newValue }
//    }
    
//    init(isFaceUp: Bool) {
//        rotation = isFaceUp ? 0 : 180
//    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: isSelected ? 5 : 1)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        //.rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    //MARK: - Drawing Constants
    private let cornerRadius: CGFloat = 10
    
}

extension View {
    func cardify(isFaceUp: Bool, isSelected: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, isSelected: isSelected))
    }
}

