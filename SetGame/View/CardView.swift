//
//  CardView.swift
//  Memorize
//
//  Created by Gavin Butler on 15-11-2020.
//

import SwiftUI

struct CardView: View {
    var card: SetGameModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            VStack {
                ForEach(1..<card.number+1) { _ in
                    ZStack {
                        if card.shape == .oval {
                            SetCapsule(rectHeight: setHeightFrom(size)).stroke(Theme.colourFor(card.colour), lineWidth: 3)
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                SetCapsule(rectHeight: setHeightFrom(size)).fill(Theme.colourFor(card.colour)).opacity(0.7)
                            }
                            if card.shading == .striped {
                                SetCapsule(rectHeight: setHeightFrom(size)).fill(ImagePaint(image: Image("hatch")))
                            }
                        } else if card.shape == .diamond {
                            Diamond(rectHeight: setHeightFrom(size)).stroke(Theme.colourFor(card.colour), lineWidth: 3)
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                Diamond(rectHeight: setHeightFrom(size)).fill(Theme.colourFor(card.colour)).opacity(0.7)
                            }
                            if card.shading == .striped {
                                Diamond(rectHeight: setHeightFrom(size)).fill(ImagePaint(image: Image("hatch")))
                            }
                        } else if card.shape == .squiggle {
                            Squiggle(rectHeight: setHeightFrom(size)).stroke(Theme.colourFor(card.colour), lineWidth: 3)
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                Squiggle(rectHeight: setHeightFrom(size)).fill(Theme.colourFor(card.colour)).opacity(0.7)
                            }
                            if card.shading == .striped {
                                Squiggle(rectHeight: setHeightFrom(size)).fill(ImagePaint(image: Image("hatch")))
                            }
                        }
                    }
                }
            }
            .padding()
            //.transition(.scale)
            //Text("\(card.id)").foregroundColor(card.number != 2 ? .white : .primary)
            Text("\(card.id)").foregroundColor(.primary)
            Image(systemName: card.isPartOfSet ? "checkmark" : "xmark")
                .font(.system(size: fontSize(for: size))
            )
                .foregroundColor(.gray)
                .opacity(card.isSetTested ? 0.4 : 0)
            RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 3)
        }
        .cardify(isFaceUp: card.isFaceUp, isSelected: card.isSelected)
        .transition(AnyTransition.identity)

    }
    
    func setHeightFrom(_ size: CGSize) -> CGFloat {
        return size.height/CGFloat(3)-shapeInset*2
    }
    
    //MARK: - Drawing Constants
    private let shapeInset: CGFloat = 10
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct CardView_Previews: PreviewProvider {
    static let theme = Theme.standard
    static var card = SetGameModel(shapes: theme.shapes, shades: theme.shades, colours: theme.colours).dealtCards.first
    
    static var previews: some View {
        return CardView(card: card!)
    }
}
