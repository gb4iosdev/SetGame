//
//  ControlView.swift
//  SetGame
//
//  Created by Gavin Butler on 09-01-2021.
//

import SwiftUI

struct ControlView: View {
    @ObservedObject var viewModel: SetGame
    
    let playerNumber: Int
    
    var body: some View {
        HStack {
            Button(action: { viewModel.checkAndDeal3(forPlayer: playerNumber) },
                   label: { Text("Deal 3")
                    .setButtonTextStyle()
                    .background(viewModel.deck.isEmpty ? Color.gray : viewModel.playerSelectedDeal3(player: playerNumber) ? Color.gray : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8)) }
            )
                .disabled(viewModel.deck.isEmpty)
                .opacity(!viewModel.deck.isEmpty ? 1.0 : 0.75)
            Button(action: { viewModel.selectNewGame(forPlayer: playerNumber) },
                   label: { Text("New Game")
                    .setButtonTextStyle()
                    .background(viewModel.playerSelectedNewGame(player: playerNumber) ? Color.gray : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8)) }
            )
            Button(action: { viewModel.cheat(forPlayer: playerNumber) },
                   label: { Text("Cheat")
                    .setButtonTextStyle()
                    .background(playerCanCheat() ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8)) }
            )
            .disabled(!playerCanCheat())
            
            if viewModel.numberOfPlayers == 2 {
                Button(action: { viewModel.setActivePlayer(playerNumber) },
                       label: { Image(systemName: "eye")
                        .padding(4)
                        .setButtonTextStyle()
                        .background(Color.blue)
                        .clipShape(Circle())
                       }
                )
            }
            
            Text("\(viewModel.scoreFor(playerNumber))")
                .foregroundColor(.blue)
                .font(.title)
        }
    }
    
    func playerCanCheat() -> Bool {
        viewModel.isCurrentlyActivePlayer(playerNumber) && !viewModel.playerHasCheated(playerNumber)
    }
}

struct ControlView_Previews: PreviewProvider {
    static let theme = Theme.standard
    
    static var previews: some View {
        let game = SetGame()
        game.setNumberOfPlayers(to: 2)
        return ControlView(viewModel: game, playerNumber: 2)
    }
}
