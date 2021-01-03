//
//  ShapeView.swift
//  SetGame
//
//  Created by Gavin Butler on 01-01-2021.
//

import SwiftUI

struct ShapeView: View {
    let card: SetGameModel.Card
    let strokeWidth: CGFloat
    var body: some View {
        ZStack {
            if card.shape == .oval {
                SetCapsule().stroke(Theme.colourFor(card.colour), lineWidth: strokeWidth)
                if card.shading != .open {
                    SetCapsule().fill(Theme.colourFor(card.colour)).opacity(0.5)
                }
                if card.shading == .striped {
                    SetCapsule().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                }
            } else if card.shape == .diamond {
                Diamond().stroke(Theme.colourFor(card.colour), lineWidth: strokeWidth)
                if card.shading != .open {
                    Diamond().fill(Theme.colourFor(card.colour)).opacity(0.5)
                }
                if card.shading == .striped {
                    Diamond().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                }
            } else if card.shape == .squiggle {
                Squiggle().stroke(Theme.colourFor(card.colour), lineWidth: strokeWidth)
                if card.shading != .open {
                    Squiggle().fill(Theme.colourFor(card.colour)).opacity(0.5)
                }
                if card.shading == .striped {
                    Squiggle().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                }
            }
        }
    }
}

struct ShapeView_Previews: PreviewProvider {
    static let theme = Theme.standard
    static var card = SetGameModel(shapes: theme.shapes, shades: theme.shades, colours: theme.colours).dealtCards.first
    
    static var previews: some View {
        ShapeView(card: card!, strokeWidth: CGFloat(2.0))
    }
}
