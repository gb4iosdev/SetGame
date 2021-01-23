//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: SetGameModel = SetGame.createSetGame()
    @Published private var bonusPoints = 0
    @Published private var chooseSeconds = 0
    
    private var bonusPointsTimer = Timer()
    private var chooseTimer = Timer()
    
    static var theme = Theme.standard
    
    private static func createSetGame() -> SetGameModel {
        return SetGameModel(shapes: theme.shapes, shades: theme.shades, colours: theme.colours)
    }
    
    var flyInOffset: CGSize = CGSize.zero
    
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
    
    var activePlayer: Int? {
        model.activePlayer
    }
    
    var setNotNoticed: Bool {
        model.setNotNoticed
    }
    
    func choose(card: SetGameModel.Card) {
        //Moved a part of this implementation out of the model in order to segregate the card in/out animation from
        //the selection and set-testing of cards which is not to be animated.
        
        //Check for a set and start to deal the next 3 (with animation) if set is found
        if model.selectedCards.count == 3 && model.numberOfPlayers == 1 {
            //If there is already a set made then this tap removes those cards and deals additional in:
            if model.makesASet(cards: model.selectedCards) {
                //Credit the player
                if let player = activePlayer {
                    addPoints(to: player, points: 1)
                }
                withAnimation(.easeOut(duration: 5)) {
                    model.removeSelectedFromPlay()
                    model.dealCards(3)
                }
                //Restart the BonusPointsTimer (Needs a delay)
                startBonusPointsTimer()
            } else {    //If 3 cards have been selected that are not a set deduct points and deselect those cards
                if let player = activePlayer {
                    addPoints(to: player, points: -1)
                }
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
            //If there is already a set made then this tap removes those cards:
            if model.makesASet(cards: model.selectedCards) {
                withAnimation(.easeOut(duration: 5)) {
                    model.removeSelectedFromPlay()
                }
            } else {    //If 3 cards have been selected that are not a set deselect those cards
                model.deselectAll()
            }
        }
        
        //Deduct points if a set exists:
        if model.foundASet(withMarking: false) {
            addPoints(to: 1, points: -1)
            if numberOfPlayers == 2 { addPoints(to: 2, points: -1) }
            withAnimation {
                setSetNotNoticed(to: true)
            }
        }
        
        
        //deal additional in
        withAnimation(.easeOut(duration: 5)) {
            model.dealCards(3)
        }
        
        //Reset the player request to deal 3 if a 2 player game
        if numberOfPlayers == 2 {
            model.resetDeal3()
        }
        
        //Restart the BonusPointsTimer (Needs a delay)
        startBonusPointsTimer()
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
            if numberOfPlayers == 1 { setActivePlayer(1) }
            self.dealInitialCards()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startBonusPointsTimer()
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
    
    //Find a set for the player requesting to cheat & mark them as having used the cheat if it finds them a set
    func cheat(forPlayer player: Int) {
        //First clear any selections
        model.deselectAll()
        if model.foundASet() {
            model.markPlayerCheated(player: player)
        }
        
        //Add a couple of seconds to the choose timer so that the player can see the selected cards
        if self.chooseSeconds < 3 {
            self.chooseSeconds += 2
        }
    }
    
    func setNumberOfPlayers(to numberOfPlayers: Int) {
        model.setNumberOfPlayers(numberOfPlayers)
    }
    
    func setActivePlayer(_ playerNumber: Int?) {
        //Stop the bonus time:
        stopBonusPointsTimer()
        //Start the choose timer if a 2 player game:
        if numberOfPlayers == 2 { startChooseTimer() }
        
        model.setActivePlayer(playerNumber)
        
    }
    
    func isCurrentlyActivePlayer(_ player: Int) -> Bool {
        model.isCurrentlyActivePlayer(player)
    }
    
    func addPoints(to player: Int, points: Int) {
        model.addPoints(to: player, points: points)
    }
}

//Timers
extension SetGame {
    
    //Bonus Points
    
    var bonusPointsAsText: String {
        self.bonusPoints == 0 ? " \(self.bonusPoints)" : "+\(self.bonusPoints)"
    }
    
    func startBonusPointsTimer() {
        self.stopBonusPointsTimer()
        bonusPoints = 5
        bonusPointsTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.bonusPoints = self.bonusPoints - 1
            if self.bonusPoints <= 0 {
                self.stopBonusPointsTimer()
            }
        }
    }
    
    func stopBonusPointsTimer() {
        bonusPointsTimer.invalidate()
    }

    
    //Choosing:
    
    var chooseSecondsRemaining: Int {
        self.chooseSeconds
    }
    
    func startChooseTimer() {
        self.stopChooseTimer()
        chooseSeconds = 5
        chooseTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.chooseSeconds = self.chooseSeconds - 1
            if self.chooseSeconds <= 0 {
                self.stopChooseTimer()
                //Make sure you have an active player:
                guard let activePlayer = self.activePlayer else { return }
                
                //If the chooseTimer is 0 and the Player hasn't chosen a set they lose 2 points, and bonus time starts again.
                if !self.model.makesASet(cards: self.model.selectedCards) {
                    self.addPoints(to: activePlayer, points: -2)
                } else {
                    self.addPoints(to: activePlayer, points: 1)
                    withAnimation(.easeOut(duration: 5)) {
                        self.model.removeSelectedFromPlay()
                        self.model.dealCards(3)
                    }
                }
                
                self.setActivePlayer(nil)
                //And clear any checkmarks that might exist (if 3 incorrect cards were chosen)
                self.model.markSelectedCards(isSetTested: false)
                self.model.markSelectedCards(isPartOfSet: false)
                self.model.deselectAll()
                
                //Restart the Bonus Points Timer
                self.startBonusPointsTimer()
            }
        }
    }
    
    func stopChooseTimer() {
        chooseTimer.invalidate()
    }
    
    func resetChooseTimer() {
        chooseTimer.invalidate()
        chooseSeconds = 0
    }
    
    func playerIsChoosing(player: Int) -> Bool {
        isCurrentlyActivePlayer(player) && chooseSecondsRemaining > 0
    }
    
    func setSetNotNoticed(to value: Bool) {
        model.setSetNotNoticed(to: value)
    }
}
