//
//  SetGameButton.swift
//  SetGame
//
//  Created by Gavin Butler on 01-01-2021.
//

import SwiftUI

struct SetGameButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .medium, design: .default))
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .foregroundColor(.white)
    }
}

extension View {
    func setButtonTextStyle() -> some View {
            self.modifier(SetGameButton())
    }
}
