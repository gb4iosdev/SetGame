//
//  ShadeType.swift
//  SetGame
//
//  Created by Gavin Butler on 25-12-2020.
//

import Foundation

enum ShadeType: CaseIterable, Identifiable {
    case solid, striped, open
    
    var id: ShadeType { self }
}
