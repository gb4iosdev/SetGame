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
            Text("\(viewModel.scoreFor(playerNumber))")
                .foregroundColor(.blue)
                .font(.title)
                .frame(minWidth: 0, maxWidth: .infinity)
            
            
            Button(action: { viewModel.checkAndDeal3(forPlayer: playerNumber) },
               label: { Text("Deal")
                .setButtonTextStyle()
                .background(disableDeal() ? Color.gray : viewModel.playerSelectedDeal3(player: playerNumber) ? Color.gray : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
               }
            )
            .disabled(disableDeal())
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear { 
                        if playerNumber == 1 {
                            //print("Geometry midY is: \(geometry.frame(in: .global).midY)")
                            //print("Geometry midX is: \(geometry.frame(in: .global).midX)")
                            viewModel.flyInOffset = CGSize(width: geometry.frame(in: .global).midX, height: geometry.frame(in: .global).midY)
                        }
                    }
            })
            
            Button(action: { viewModel.selectNewGame(forPlayer: playerNumber) },
                   label: { Text("New")
                    .setButtonTextStyle()
                    .background(viewModel.playerSelectedNewGame(player: playerNumber) ? Color.gray : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8)) }
            )
            .frame(minWidth: 0, maxWidth: .infinity)
            Button(action: { viewModel.cheat(forPlayer: playerNumber) },
                   label: { Text("Cheat")
                    .setButtonTextStyle()
                    .background(playerCanCheat() ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8)) }
            )
            .disabled(!playerCanCheat())
            .frame(minWidth: 70, maxWidth: .infinity)
            
            if viewModel.numberOfPlayers == 2 {
                ZStack {
                    Button(action: { viewModel.setActivePlayer(playerNumber) },
                           label: { Image(systemName: "eye")
                            .padding(4)
                            .setButtonTextStyle()
                            .background(viewModel.activePlayer == nil || viewModel.isCurrentlyActivePlayer(playerNumber) ? Color.blue : Color.gray)
                            .clipShape(Circle())
                           }
                    )
                    .opacity(viewModel.playerIsChoosing(player: playerNumber) ? 0 : 1)
                    .disabled(disableEye())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    Text("\(viewModel.chooseSecondsRemaining)")
                        .foregroundColor(.blue)
                        .font(.title)
                        .opacity(viewModel.playerIsChoosing(player: playerNumber) ? 1 : 0)
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            
            
            Text("\(viewModel.bonusPointsAsText)")
                .foregroundColor(.blue)
                .font(.title)
        }
    }
}

extension ControlView {
    func playerCanCheat() -> Bool {
        //Can cheat if they're the active player, and haven't cheated before
        viewModel.activePlayer == playerNumber && !viewModel.playerHasCheated(playerNumber)
    }
    
    func disableEye() -> Bool {
        viewModel.activePlayer != nil && (viewModel.playerIsChoosing(player: playerNumber) || !viewModel.isCurrentlyActivePlayer(playerNumber))
    }
    
    func disableDeal() -> Bool {
        viewModel.deck.isEmpty || (viewModel.numberOfPlayers == 2 && viewModel.activePlayer != nil)
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
