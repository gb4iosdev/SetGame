//
//  SetGameView.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGame
    
    var body: some View {
        VStack {
            Grid(viewModel.activeCards) { card in
                CardView(card: card)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 1)) {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
                    .aspectRatio(0.75, contentMode: .fit)
                    //.transition(.scale)
                    .transition(.offset(CGSize(width: CGFloat.random(in: -40...0)*20, height: CGFloat.random(in: -40...0)*20)))
                    //.animation(.linear(duration: 1))
            }
            HStack {
                Button(action: {
                    viewModel.checkAndDeal3()
                }, label: {
                    Text("Deal 3")
                        .setButtonTextStyle()
                        .background(!viewModel.deck.isEmpty ? Color.blue : Color.gray)
                })
                .disabled(viewModel.deck.isEmpty)
                .opacity(!viewModel.deck.isEmpty ? 1.0 : 0.75)
                Button(action: {
                    withAnimation(.easeInOut(duration: 3)) {
                        viewModel.restart()
                    }
                }, label: {
                    Text("New Game")
                        .setButtonTextStyle()
                })
                Button(action: {
                    viewModel.findASet()
                }, label: {
                    Text("Find A Set")
                        .setButtonTextStyle()
                    
                })
                Button(action: {
                    withAnimation(.easeInOut(duration: 3)) {
                        viewModel.flipCards()
                    }
                }, label: {
                    Text("Flip")
                        .setButtonTextStyle()
                })
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                viewModel.dealInitialCards()
            }
            withAnimation(Animation.easeInOut(duration: 1).delay(1)) {
                viewModel.flipCards()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(viewModel: game)
    }
}
