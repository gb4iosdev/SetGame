//
//  CardView.swift
//  Memorize
//
//  Created by Gavin Butler on 15-11-2020.
//

import SwiftUI

struct CardView: View {
    var card: SetGameModel.Card
    @ObservedObject var viewModel: SetGame
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size, frame: geometry.frame(in: .global))
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize, frame: CGRect) -> some View {
        ZStack {
            VStack {
                Spacer()
                ForEach(1..<card.numberOfShapes+1) { _ in
                    Spacer(minLength: setSpacerHeight(size))
                    ShapeView(card: card, strokeWidth: strokeLineWidth(for: size))
                    Spacer(minLength: setSpacerHeight(size))
                }
                Spacer()
            }
            .padding(.horizontal, horizontalPadding(for: size))
            
            Text("\(card.cardNum)").foregroundColor(.primary)
            Image(systemName: card.isPartOfSet ? "checkmark" : "xmark")
                .font(.system(size: fontSize(for: size))
            )
                .foregroundColor(.gray)
                .opacity(card.isSetTested ? 0.4 : 0)
            RoundedRectangle(cornerRadius: 10).stroke(viewModel.gameIsActive ? Color.blue : Color.gray, lineWidth: 3)
        }
        .cardify(isFaceUp: card.isFaceUp, isSelected: card.isSelected, colour: card.colour)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5).delay(0.5+Double(viewModel.indexFor(card))*0.1)) {
                viewModel.flip(card)
            }
        }
    }
    
    func setSpacerHeight(_ size: CGSize) -> CGFloat {
        switch card.numberOfShapes {
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
        let game = SetGame()
        return CardView(card: card!, viewModel: game)
    }
}
