//
//  NoticeView.swift
//  SetGame
//
//  Created by Gavin Butler on 17-01-2021.
//

import SwiftUI

struct NoticeView: View {
    
    let message = "Set was missed !!"
    let additionalMessage = "1 point deducted"
    
    @ObservedObject var viewModel: SetGame

        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                if viewModel.numberOfPlayers == 2 {
                    NoticeText(message: message, additionalMessage: additionalMessage)
                        .rotationEffect(.degrees(180))
                }
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 72, weight: .regular))
                    .padding()
                
                NoticeText(message: message, additionalMessage: additionalMessage)
            }
            .background(Color.gray.opacity(0.85))
            .cornerRadius(5)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    viewModel.setSetNotNoticed(to: false)
                })
            })
        }
}

struct NoticeText: View {
    
    let message: String
    let additionalMessage: String?

    var body: some View {
        VStack {
            Text(message)
            if additionalMessage != nil {
                Text(additionalMessage ?? "")
            }
        }
        .foregroundColor(.white)
        .font(.callout)
        .padding(10)
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        NoticeView(viewModel: game)
    }
}
