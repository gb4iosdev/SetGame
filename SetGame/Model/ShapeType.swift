//
//  ShapeType.swift
//  SetGame
//
//  Created by Gavin Butler on 25-12-2020.
//

import Foundation

enum ShapeType: CaseIterable, Identifiable {
    case diamond, squiggle, oval
    
    var id: ShapeType { self }
}
