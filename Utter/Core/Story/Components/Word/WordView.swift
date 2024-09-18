//
//  WordView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct WordView: View {
    let word: String
    let action: (String) -> Void

    var body: some View {
        Button(action: {
            action(word)
        }) {
            Text(word)
                .font(.headline)
                .foregroundColor(Color("TextColor"))
                .underline(true, color: Color("TextColor"))
        }
        .buttonStyle(.plain)
    }
}


//#Preview {
//    WordView(word: "potato") {
//        print("Potato pressed")
//    }
//}
