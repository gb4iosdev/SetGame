//
//  SetGameModel.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

struct SetGameModel {
    private(set) var deck: Array<Card>          //Entire deck of 81 cards
    private(set) var nextCard = 0               //Array position of the next card to be dealt - used to set card ID's
    private(set) var dealtCards: Array<Card>    //Dealt cards
    private(set) var numberOfPlayers = 1
    private(set) var activePlayer: Int?      //The player doing the selecting in a 2 player game
    private(set) var player1 = Player()
    private(set) var player2 = Player()         //Ignored if a one player game
    
    
    var selectedCards: [Card] {
        return dealtCards.filter { $0.isSelected }
    }
    
    var gameIsActive: Bool {
        return numberOfPlayers == 1 || activePlayer != nil
    }
    
    init(shapes: [ShapeType], shades: [ShadeType], colours: [ShapeColour]) {
        self.deck = [Card]()
        var cardNum: Int = 0
        
        //Build the deck of 81 cards
        for i in 1...3 {
            for shape in shapes {
                for shade in shades {
                    for colour in colours {
                        cardNum += 1
                        let card = Card(cardNum: cardNum, numberOfShapes: i, shape: shape, shading: shade, colour: colour)
                        deck.append(card)
                    }
                }
            }
        }
        deck.shuffle()
        
        //Set up the dealtCardsDeck:
        self.dealtCards = [Card]()
    }
    
    mutating func dealCards(_ numberToDeal: Int) {
        //Must have cards to deal from:
        guard deck.count > 0 else { return }
        
        let dealNumber = min(numberToDeal, deck.count)
        for _ in 1...dealNumber {
            dealtCards.append(deck.removeFirst())
        }
    }
    
    mutating func flipAllCardsUp() {
        for i in 0..<dealtCards.count {
            dealtCards[i].isFaceUp = true
        }
    }
    
    mutating func flip(_ card: Card) {
        dealtCards[dealtCards.firstIndex(matching: card)!].isFaceUp.toggle()
    }
    
    func indexFor(_ card: Card) -> Int {
        dealtCards.firstIndex(matching: card)!
    }
    
    //*** Method only required to test card resizing UI - remove before completion ***//
    mutating func removeCards(_ numberToRemove: Int) {
        if dealtCards.count >= numberToRemove {
            for _ in 0..<numberToRemove {
                deck.append(dealtCards.removeFirst())
            }
        }
    }
    
    mutating func markAndTest(_ card: Card) {
        
        //Don't mark if a 2 player game without an active user
        if !(numberOfPlayers == 2 && activePlayer == nil) {
            markSelected(card)
        }
        
        //If this is the third card selected: Time to test for a set
        if selectedCards.count == 3 {
            if makesASet(cards: selectedCards) {
                markSelectedCards(isPartOfSet: true)    //User has just chosen the 3rd card and made a set - simply mark the cards as being part of a set
            } else {
                markSelectedCards(isPartOfSet: false)
            }
            markSelectedCards(isSetTested: true)
        }
    }
    
    //Triggered by the 'Deal 3' Button - always deals 3 cards, but first checks for a set and removes those cards if a set is made
    mutating func dealCardsWithCheck() {
        //If there is already a set made then this button removes those cards and deals additional in:
        if selectedCards.count == 3 && makesASet(cards: selectedCards) {
            removeSelectedFromPlay()
        }
        dealCards(3)
    }
    
    mutating func deselectAll() {
        for i in 0..<dealtCards.count {
            dealtCards[i].isSelected = false
            dealtCards[i].isSetTested = false
            dealtCards[i].isPartOfSet = false
        }
    }
    
    //Remove cards that have been selected from the Dealt Cards
    mutating func removeSelectedFromPlay() {
        for card in dealtCards {
            if card.isSelected == true {
                let index = dealtCards.firstIndex(matching: card)!
                dealtCards[index].isFaceUp = false
                dealtCards.remove(at: index)
            }
        }
    }
    
    mutating func removeAllDealt() {
        dealtCards.removeAll()
    }
    
    mutating func markSelected(_ card: Card) {
        if let index = dealtCards.firstIndex(matching: card) {
            dealtCards[index].isSelected.toggle()
        }
    }
    
    mutating func markSelectedCards(isPartOfSet: Bool) {
        for card in selectedCards {
            dealtCards[dealtCards.firstIndex(matching: card)!].isPartOfSet = isPartOfSet
        }
    }
    
    mutating func markSelectedCards(isSetTested: Bool) {
        for card in selectedCards {
            dealtCards[dealtCards.firstIndex(matching: card)!].isSetTested = isSetTested
        }
    }
    
    mutating func markPlayerCheated(player: Int) {
        switch player {
        case 1: player1.hasCheatedThisGame = true
        case 2: player2.hasCheatedThisGame = true
        default: break
        }
    }
    
    mutating func setNumberOfPlayers(_ numberOfPlayers: Int) {
        switch numberOfPlayers {
        case 1, 2:
            self.numberOfPlayers = numberOfPlayers
        default:
            return
        }
    }
    
    mutating func playerSelectedNewGame(player: Int) {
        switch player {
        case 1: player1.selectedNewGame.toggle()
        case 2: player2.selectedNewGame.toggle()
        default: break
        }
    }
    
    mutating func playerSelectedDeal3(player: Int) {
        switch player {
        case 1: player1.selectedToDeal3.toggle()
        case 2: player2.selectedToDeal3.toggle()
        default: break
        }
    }
    
    mutating func resetDeal3() {
        player1.selectedToDeal3 = false
        player2.selectedToDeal3 = false
    }
    
    mutating func setActivePlayer(_ playerNumber: Int?) {
        activePlayer = playerNumber
    }
    
    func isCurrentlyActivePlayer(_ player: Int) -> Bool {
        if gameIsActive {
            if let playerNumber = activePlayer, playerNumber == player {
                return true
            }
        }
        return false
    }
    
    //Determine if there is a set in the currently dealt cards
    mutating func findASet() {
        //Must have cards dealt
        guard dealtCards.count >= 3 else { return }
        
        for i in 0..<dealtCards.count-2 {
            for j in i+1..<dealtCards.count-1 {
                for k in j+1..<dealtCards.count {
                    if makesASet(cards: [dealtCards[i], dealtCards[j], dealtCards[k]]) {
                        dealtCards[i].isSetTested = true
                        dealtCards[i].isPartOfSet = true
                        dealtCards[i].isSelected = true
                        dealtCards[j].isSetTested = true
                        dealtCards[j].isPartOfSet = true
                        dealtCards[j].isSelected = true
                        dealtCards[k].isSetTested = true
                        dealtCards[k].isPartOfSet = true
                        dealtCards[k].isSelected = true
                        return
                    }
                }
            }
        }
    }
    
    func makesASet(cards: [Card]) -> Bool {
        //Must be comparing 3 cards
        guard cards.count == 3 else { return false }
        
        //They all have the same number or have three different numbers.
        guard featureAllSameOrDifferent(cards[0].numberOfShapes, cards[1].numberOfShapes, cards[2].numberOfShapes) else {
            return false }
        
        //They all have the same shape or have three different shapes.
        guard featureAllSameOrDifferent(cards[0].shape, cards[1].shape, cards[2].shape) else {
            return false }
        
        //They all have the same shading or have three different shadings.
        guard featureAllSameOrDifferent(cards[0].shading, cards[1].shading, cards[2].shading) else {
            return false }
        
        //They all have the same color or have three different colors.
        guard featureAllSameOrDifferent(cards[0].colour, cards[1].colour, cards[2].colour) else {
            return false }
        
        return true
    }
    
    private func featureAllSameOrDifferent<T1: Equatable>(_ feature1: T1, _ feature2: T1, _ feature3: T1) -> Bool {
        return feature1 == feature2 && feature2 == feature3
            || (feature1 != feature2 && feature2 != feature3 && feature1 != feature3)
    }
    
    struct Card: Identifiable {
        let id = UUID()
        let cardNum: Int    //card number in the deck
        let numberOfShapes: Int     //Number of Shapes
        let shape: ShapeType
        let shading: ShadeType
        let colour: ShapeColour
        
        var isFaceUp: Bool = false
        var isSelected: Bool = false
        var isPartOfSet: Bool = false
        var isSetTested: Bool = false

        
        func description() -> String {
            return """
                Card: \(self.id)
                Number: \(self.numberOfShapes)
                Shape: \(self.shape)
                Shading: \(self.shading)
                Colour: \(self.colour)
            """
        }
    }
    
    struct Player {
        var selectedNewGame = false
        var selectedToDeal3 = false
        var hasCheatedThisGame = false
        var score: Int = 0
    }
}
