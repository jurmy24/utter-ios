//
//  ExerciseBlockView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct ExerciseBlockView: View {
    let exercise: ExerciseOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Exercise: \(exercise.type)")
                .font(.headline)
            
            if let query = exercise.query {
                Text(query)
                    .font(.body)
            }
            
            if let answerOptions = exercise.answerOptions {
                ForEach(Array(answerOptions.keys), id: \.self) { key in
                    if let option = answerOptions[key] {
                        Button(action: {
                            // Handle answer selection
                        }) {
                            Text(option.text)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

//#Preview {
//    ExerciseBlockView()
//}
