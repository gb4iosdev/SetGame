//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: SetGameModel = SetGame.createSetGame()
    
    private static func createSetGame() -> SetGameModel {
        return SetGameModel()
    }
    
    //MARK: - Access to the Model
    
    var deck: Array<SetGameModel.Card> {
        model.deck
    }
    
    var activeCards: Array<SetGameModel.Card> {
        model.activeCards
    }
}
