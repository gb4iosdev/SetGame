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
                    Squiggle(rectHeight: setHeightFrom(size)).stroke(Color.green, lineWidth: 3)
                        .padding(.vertical, shapeInset)
                }
            }
            .padding()
            //.transition(.scale)
            //Text("\(card.id)").foregroundColor(card.number != 2 ? .white : .primary)
            Text("\(card.id)").foregroundColor(.primary)
        }
        .cardify(isFaceUp: card.isFaceUp)
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
    static var card = SetGameModel().activeCards.first
    
    static var previews: some View {
        return CardView(card: card!)
    }
}
