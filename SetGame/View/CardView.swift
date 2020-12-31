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
                Spacer()
                ForEach(1..<card.number+1) { _ in
                    Spacer(minLength: setSpacerHeight(size))
                    ZStack {
                        if card.shape == .oval {
                            SetCapsule().stroke(Theme.colourFor(card.colour), lineWidth: strokeLineWidth(for: size))
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                SetCapsule().fill(Theme.colourFor(card.colour)).opacity(0.5)
                            }
                            if card.shading == .striped {
                                SetCapsule().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                            }
                        } else if card.shape == .diamond {
                            Diamond().stroke(Theme.colourFor(card.colour), lineWidth: strokeLineWidth(for: size))
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                Diamond().fill(Theme.colourFor(card.colour)).opacity(0.5)
                            }
                            if card.shading == .striped {
                                Diamond().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                            }
                        } else if card.shape == .squiggle {
                            Squiggle().stroke(Theme.colourFor(card.colour), lineWidth: strokeLineWidth(for: size))
                                .padding(.vertical, shapeInset)
                            if card.shading != .open {
                                Squiggle().fill(Theme.colourFor(card.colour)).opacity(0.5)
                            }
                            if card.shading == .striped {
                                Squiggle().fill(ImagePaint(image: Image("hatch"))).foregroundColor(Theme.colourFor(card.colour))
                            }
                        }
                    }
                    Spacer(minLength: setSpacerHeight(size))
                }
                Spacer()
            }
            .padding(.horizontal, horizontalPadding(for: size))
            
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
    
    func setSpacerHeight(_ size: CGSize) -> CGFloat {
        switch card.number {
        case 1:
            return CGFloat(size.height / 3)
        case 2:
            return CGFloat(size.height / 10)
        default:
            return CGFloat(size.height / 20)
        }
    }
    
    //MARK: - Drawing Constants
    private let shapeInset: CGFloat = 0    //Sets vertical spacing between shapes
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    private func horizontalPadding(for size: CGSize) -> CGFloat {
        size.width/10
    }
    private func strokeLineWidth(for size: CGSize) -> CGFloat {
        switch size.width {
            case 0..<70: return CGFloat(1)
            case 70..<120: return CGFloat(2)
            default: return CGFloat(3)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static let theme = Theme.standard
    static var card = SetGameModel(shapes: theme.shapes, shades: theme.shades, colours: theme.colours).dealtCards.first
    
    static var previews: some View {
        return CardView(card: card!)
    }
}
