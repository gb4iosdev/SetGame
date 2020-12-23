//
//  SetGameModel.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import Foundation

struct SetGameModel {
    private(set) var deck: Array<Card>
    private(set) var nextCard = 0          //Array position of the next card to be dealt
    private(set) var activeCards: Array<Card>
    
    init() {
        self.deck = [Card]()
        var cardId: Int = 0
        for i in 1...3 {
            for shape in ShapeType.allCases {
                for shade in ShadeType.allCases {
                    for colour in ShapeColour.allCases {
                        cardId += 1
                        let card = Card(id: cardId, number: i, shape: shape, shading: shade, colour: colour)
                        deck.append(card)
                    }
                }
            }
        }
        deck.shuffle()
        
        //Deal the first 12 cards
        self.activeCards = [Card]()
        for _ in 0...11 {
            activeCards.append(deck.removeFirst())
        }
    }
    
    struct Card: Identifiable {
        let id: Int
        let number: Int     //Number of Shapes
        let shape: ShapeType
        let shading: ShadeType
        let colour: ShapeColour
        
        var isFaceUp: Bool = true
        
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
    
    enum ShapeType: CaseIterable {
        case diamond, squiggle, oval
    }
    
    enum ShadeType: CaseIterable {
        case solid, striped, open
    }
    
    enum ShapeColour: CaseIterable {
        case green, purple, red
    }
    
    //Returns true if the cards passed in constitute a deck
    func isASet(card1: Card, card2: Card, card3: Card) -> Bool {
        
        //They all have the same number or have three different numbers.
        guard featureAllSameOrDifferent(card1.number, card2.number, card3.number) else { return false }
        
        //They all have the same shape or have three different shapes.
        guard featureAllSameOrDifferent(card1.shape, card2.shape, card3.shape) else { return false }
        
        //They all have the same shading or have three different shadings.
        guard featureAllSameOrDifferent(card1.shading, card2.shading, card3.shading) else { return false }
        
        //They all have the same color or have three different colors.
        guard featureAllSameOrDifferent(card1.colour, card2.colour, card3.colour) else { return false }
        
        return true
    }
    
    private func featureAllSameOrDifferent<T1: Equatable>(_ feature1: T1, _ feature2: T1, _ feature3: T1) -> Bool {
        return feature1 == feature2 && feature2 == feature3
            || feature1 != feature2 && feature2 != feature2 && feature1 != feature3
    }
}
