//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: SetGameModel = SetGame.createSetGame()
    static var theme = Theme.standard
    
    private static func createSetGame() -> SetGameModel {
        return SetGameModel(shapes: theme.shapes, shades: theme.shades, colours: theme.colours)
    }
    
    //MARK: - Access to the Model
    
    var deck: Array<SetGameModel.Card> {
        model.deck
    }
    
    var activeCards: Array<SetGameModel.Card> {
        model.dealtCards
    }
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    func checkAndDeal3() {
        model.dealCardsWithCheck()
    }
    
    //***Used only for testing - remove later***
    func removeCards(_ numberToRemove: Int) {
        model.removeCards(numberToRemove)
    }
    
    func restart() {
        self.model = SetGame.createSetGame()
    }
    
    func findASet() {
        model.findASet()
    }
}
