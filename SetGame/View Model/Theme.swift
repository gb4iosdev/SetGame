//
//  Theme.swift
//  SetGame
//
//  Created by Gavin Butler on 25-12-2020.
//

import SwiftUI

enum Theme {
    case standard
    case random
    
    var shapes: [ShapeType] {
        switch self {
            case .standard: return [ShapeType.diamond, ShapeType.squiggle, ShapeType.oval]
            case .random: return ShapeType.allCases.shuffled().firstElements(3)
        }
    }
    
    var shades: [ShadeType] {
        switch self {
            case .standard: return [ShadeType.open, ShadeType.solid, ShadeType.striped]
            case .random: return ShadeType.allCases.shuffled().firstElements(3)
        }
    }
    
    var colours: [ShapeColour] {
        switch self {
            case .standard: return [ShapeColour.green, ShapeColour.purple, ShapeColour.red]
            case .random: return ShapeColour.allCases.shuffled().firstElements(3)
        }
    }
    
    static func colourFor(_ colour: ShapeColour) -> Color {
        switch colour {
        case .green: return Color.green
        case .purple: return Color.purple
        case .red: return Color.red
        }
    }
}

