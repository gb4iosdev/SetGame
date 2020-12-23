//
//  SetGameApp.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            let game = SetGame()
            SetGameView(viewModel: game)
        }
    }
}
