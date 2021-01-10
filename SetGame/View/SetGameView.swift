//
//  SetGameView.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGame
    @State private var showingNumberOfPlayersSelection = false
    
    var body: some View {
        VStack {
            if viewModel.numberOfPlayers == 2 {
                ControlView(viewModel: viewModel, playerNumber: 2)
                    .rotationEffect(.degrees(180))
            }
            Grid(viewModel.dealtCards) { card in
                CardView(card: card, viewModel: viewModel)
                    .onTapGesture {
                        if viewModel.gameIsActive {
                            viewModel.choose(card: card)
                        }
                    }
                    .padding(5)
                    .aspectRatio(0.75, contentMode: .fit)
                    .transition(.asymmetric(insertion: AnyTransition.offset(offsetForIncomingCard(card: card)), removal: AnyTransition.offset(offsetForOutgoingCard(card: card))))
            }
            ControlView(viewModel: viewModel, playerNumber: 1)
        }
        .actionSheet(isPresented: $showingNumberOfPlayersSelection, content: {
            ActionSheet(title: Text("Welcome to the SET GAME.  Select Number of Players"), buttons: [
                .default(Text("1 Player")) {  },    //Default numberOFPlayers is already 1
                .default(Text("2 Players")) { withAnimation { viewModel.setNumberOfPlayers(to: 2) } }
            ])
        })
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                viewModel.dealInitialCards()
            }
            showingNumberOfPlayersSelection = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(viewModel: game)
    }
}

extension SetGameView {
    func offsetForIncomingCard(card: SetGameModel.Card) -> CGSize {
        let cardIndex = viewModel.indexFor(card)
        return CGSize(width: -40-cardIndex*40, height: -40-cardIndex*40)
    }
    func offsetForOutgoingCard(card: SetGameModel.Card) -> CGSize {
        let cardIndex = viewModel.indexFor(card)
        return CGSize(width: 400+(viewModel.dealtCards.count - cardIndex)*40, height: 600+(viewModel.dealtCards.count - cardIndex)*40)
    }
}
