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
                    ShapeView(card: card, strokeWidth: strokeLineWidth(for: size))
                        //.rotation3DEffect(.degrees(card.isPartOfSet ? 360 : 0), axis: (x: 1.0, y: 0.0, z: 0.0))
                        //.animation(Animation.linear(duration: 1))
                    Spacer(minLength: setSpacerHeight(size))
                }
                Spacer()
            }
            .padding(.horizontal, horizontalPadding(for: size))
            
            Text("\(card.id)").foregroundColor(.primary)
            Image(systemName: card.isPartOfSet ? "checkmark" : "xmark")
                .font(.system(size: fontSize(for: size))
            )
                .foregroundColor(.gray)
                .opacity(card.isSetTested ? 0.4 : 0)
            RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 3)
        }
        .cardify(isFaceUp: card.isFaceUp, isSelected: card.isSelected, colour: card.colour)
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
