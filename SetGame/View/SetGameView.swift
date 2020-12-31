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
                        withAnimation(.easeOut) {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
                    .aspectRatio(0.75, contentMode: .fit)
            }
            HStack {
                Button(action: {
                    viewModel.checkAndDeal3()
                }, label: {
                    Text("Deal 3")
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(!viewModel.deck.isEmpty ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                .disabled(viewModel.deck.isEmpty)
                .opacity(!viewModel.deck.isEmpty ? 1.0 : 0.75)
                Button(action: {
                    viewModel.restart()
                }, label: {
                    Text("New Game")
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                })
                Button(action: {
                    viewModel.findASet()
                }, label: {
                    Text("Find A Set")
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                })
            }
        }
        //.foregroundColor(.orange)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(viewModel: game)
    }
}
