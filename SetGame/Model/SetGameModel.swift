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
        
        //Deal the first 12 cards
        self.dealtCards = [Card]()
        for _ in 0...11 {
            dealtCards.append(deck.removeFirst())
        }
    }
    
    mutating func choose(card: Card) {
        
        guard let cardIndex = dealtCards.firstIndex(matching: card) else { return }
        
        dealtCards[cardIndex].isSelected.toggle()
        
        if selectedCards.count == 3 { //Time to test for a set
            if makesASet(cards: selectedCards) {
                dealtCards[dealtCards.firstIndex(matching: selectedCards[0])!].isPartOfSet = true
                dealtCards[dealtCards.firstIndex(matching: selectedCards[1])!].isPartOfSet = true
                dealtCards[dealtCards.firstIndex(matching: selectedCards[2])!].isPartOfSet = true
            } else {
                dealtCards[dealtCards.firstIndex(matching: selectedCards[0])!].isPartOfSet = false
                dealtCards[dealtCards.firstIndex(matching: selectedCards[1])!].isPartOfSet = false
                dealtCards[dealtCards.firstIndex(matching: selectedCards[2])!].isPartOfSet = false
            }
            dealtCards[dealtCards.firstIndex(matching: selectedCards[0])!].isSetTested = true
            dealtCards[dealtCards.firstIndex(matching: selectedCards[1])!].isSetTested = true
            dealtCards[dealtCards.firstIndex(matching: selectedCards[2])!].isSetTested = true
        }
        
        
    }
    
    func makesASet(cards: [Card]) -> Bool {
        print("Checking for a set!!")
        //Must be comparing 3 cards
        guard cards.count == 3 else { return false }
        
        //They all have the same number or have three different numbers.
        guard featureAllSameOrDifferent(cards[0].number, cards[1].number, cards[2].number) else {
            print("number of shapes is not all the same or different")
            return false }
        
        //They all have the same shape or have three different shapes.
        guard featureAllSameOrDifferent(cards[0].shape, cards[1].shape, cards[2].shape) else {
            print("shape type is not all the same or different")
            return false }
        
        //They all have the same shading or have three different shadings.
        guard featureAllSameOrDifferent(cards[0].shading, cards[1].shading, cards[2].shading) else {
            print("shading is not all the same or different")
            return false }
        
        //They all have the same color or have three different colors.
        guard featureAllSameOrDifferent(cards[0].colour, cards[1].colour, cards[2].colour) else {
            print("colour is not all the same or different")
            return false }
        
        print("Found a set!!")
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
        
        var isFaceUp: Bool = true
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
