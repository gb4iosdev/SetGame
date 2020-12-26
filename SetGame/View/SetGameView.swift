//
//  SetGameView.swift
//  SetGame
//
//  Created by Gavin Butler on 16-12-2020.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGame
    
    var body: some View {
        
        Grid(viewModel.activeCards) { card in
            CardView(card: card)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
        }
        //.foregroundColor(.orange)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        SetGameView(viewModel: game)
    }
}
