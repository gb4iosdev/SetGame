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
    
    var selectedCards: [Card] {
        return dealtCards.filter { $0.isSelected }
    }
    
    init(shapes: [ShapeType], shades: [ShadeType], colours: [ShapeColour]) {
        self.deck = [Card]()
        var cardId: Int = 0
        
        //Build the deck of 81 cards
        for i in 1...3 {
            for shape in shapes {
                for shade in shades {
                    for colour in colours {
                        cardId += 1
                        let card = Card(id: cardId, number: i, shape: shape, shading: shade, colour: colour)
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
    
    mutating func flipCards() {
        for i in 0..<dealtCards.count {
            dealtCards[i].isFaceUp.toggle()
        }
    }
    
    //*** Method only required to test card resizing UI - remove before completion ***//
    mutating func removeCards(_ numberToRemove: Int) {
        if dealtCards.count >= numberToRemove {
            for _ in 0..<numberToRemove {
                deck.append(dealtCards.removeFirst())
            }
        }
    }
    
    mutating func choose(card: Card) {
        
        if selectedCards.count == 3 {
            //If there is already a set made then this tap removes those cards and deals additional in:
            if makesASet(cards: selectedCards) {
                removeSelectedFromPlay()
                dealCards(3)
            } else {    //If 3 cards have been selected that are not a set deselect those cards
                deselectAll()
            }
        }
        
        markSelected(card)
        
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
        }
    }
    
    mutating func removeSelectedFromPlay() {
        var selectedCardIds = [Int]()
        for card in selectedCards {
            selectedCardIds.append(card.id)
        }
        for card in dealtCards {
            if selectedCardIds.contains(card.id) {
                dealtCards.remove(at: dealtCards.firstIndex(matching: card)!)
            }
        }
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
                        dealtCards[j].isSetTested = true
                        dealtCards[j].isPartOfSet = true
                        dealtCards[k].isSetTested = true
                        dealtCards[k].isPartOfSet = true
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
        guard featureAllSameOrDifferent(cards[0].number, cards[1].number, cards[2].number) else {
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
        let id: Int
        let number: Int     //Number of Shapes
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
                Number: \(self.number)
                Shape: \(self.shape)
                Shading: \(self.shading)
                Colour: \(self.colour)
            """
        }
    }
}
