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
    
    var dealtCards: Array<SetGameModel.Card> {
        model.dealtCards
    }
    
    var numberOfPlayers: Int {
        model.numberOfPlayers
    }
    
    var gameIsActive: Bool {
        model.gameIsActive
    }
    
    func choose(card: SetGameModel.Card) {
        //Moved a part of this implementation out of the model in order to segregate the card in/out animation from
        //the selection and set-testing of cards which is not to be animated.
        
        //Check for a set and start to deal the next 3 (with animation) if set is found
        if model.selectedCards.count == 3 {
            //If there is already a set made then this tap removes those cards and deals additional in:
            if model.makesASet(cards: model.selectedCards) {
                withAnimation(.easeOut(duration: 5)) {
                    model.removeSelectedFromPlay()
                    model.dealCards(3)
                    model.setActivePlayer(nil)
                }
            } else {    //If 3 cards have been selected that are not a set deselect those cards
                model.deselectAll()
            }
        }
        
        //Mark the chosen card as selected and test for a set (no animation)
        model.markAndTest(card)
    }
    
    func checkAndDeal3(forPlayer player: Int) {
        //Record the players request to deal 3 (If a 2 player game):
        if numberOfPlayers == 2 {
            switch player {
            case 1: model.playerSelectedDeal3(player: 1)
            case 2: model.playerSelectedDeal3(player: 2)
            default: return
            }
        }
        
        //If a 2 player game must have both player's consent
        guard numberOfPlayers == 1 || (model.player1.selectedToDeal3 && model.player2.selectedToDeal3) else { return }

        if model.selectedCards.count == 3 {
            //If there is already a set made then this tap removes those cards and deals additional in:
            if model.makesASet(cards: model.selectedCards) {
                withAnimation(.easeOut(duration: 5)) {
                    model.removeSelectedFromPlay()
                }
            } else {    //If 3 cards have been selected that are not a set deselect those cards
                model.deselectAll()
            }
        }
        withAnimation(.easeOut(duration: 5)) {
            model.dealCards(3)
        }
        
        //Reset the player request to deal 3 if a 2 player game
        if numberOfPlayers == 2 {
            model.resetDeal3()
        }
    }
    
    //Deal the 12 initial cards
    func dealInitialCards() {
        model.dealCards(12)
    }
    
    func flipAllCardsUp() {
        model.flipAllCardsUp()
    }
    
    func flip(_ card: SetGameModel.Card) {
        model.flip(card)
    }
    
    func indexFor(_ card: SetGameModel.Card) -> Int {
        model.indexFor(card)
    }
    
    //***Used only for testing - remove later***
    func removeCards(_ numberToRemove: Int) {
        model.removeCards(numberToRemove)
    }
    
    func selectNewGame(forPlayer player: Int) {
        //Record the players request for a new game:
        switch player {
        case 1: model.playerSelectedNewGame(player: 1)
        case 2: model.playerSelectedNewGame(player: 2)
        default: return
        }
        
        //If a 2 player game must have both player's consent
        guard numberOfPlayers == 1 || (model.player1.selectedNewGame && model.player2.selectedNewGame) else { return }
        
        let currentNumberOfPlayers = model.numberOfPlayers
        
        withAnimation(.easeInOut(duration: 3)) {
            self.model = SetGame.createSetGame()
            setNumberOfPlayers(to: currentNumberOfPlayers)
            self.dealInitialCards()
        }
    }
    
    func playerSelectedNewGame(player: Int) -> Bool {
        switch player {
        case 1: return model.player1.selectedNewGame
        case 2: return model.player2.selectedNewGame
        default: return false
        }
    }
    
    func playerSelectedDeal3(player: Int) -> Bool {
        switch player {
        case 1: return model.player1.selectedToDeal3
        case 2: return model.player2.selectedToDeal3
        default: return false
        }
    }
    
    func scoreFor(_ player: Int) -> Int {
        switch player {
        case 1: return model.player1.score
        case 2: return model.player2.score
        default: return 0
        }
    }
    
    func playerHasCheated(_ player: Int) -> Bool {
        switch player {
        case 1: return model.player1.hasCheatedThisGame
        case 2: return model.player2.hasCheatedThisGame
        default: return false
        }
    }
    
    //Find a set for the player requesting to cheat & mark them as having used the cheat (even if the cards aren't found - bad luck)
    func cheat(forPlayer player: Int) {
        //First clear any selections
        model.deselectAll()
        model.findASet()
        model.markPlayerCheated(player: player)
    }
    
    func setNumberOfPlayers(to numberOfPlayers: Int) {
        model.setNumberOfPlayers(numberOfPlayers)
    }
    
    func setActivePlayer(_ playerNumber: Int?) {
        withAnimation(.easeOut(duration: 1)) {
            model.setActivePlayer(playerNumber)
        }
    }
    
    func isCurrentlyActivePlayer(_ player: Int) -> Bool {
        model.isCurrentlyActivePlayer(player)
    }
}
