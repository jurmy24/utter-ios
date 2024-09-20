//
//  ExerciseHeaderView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct ExerciseHeaderView: View {
    let exercise: ExerciseOption
    let colors: ExerciseColors
    
    var body: some View {
        HStack {
            Text("\(exercise.type.displayName)")
                .font(.headline)
                .foregroundColor(colors.text)
            Spacer()
            Text("CEFR: \(exercise.cefr.map { $0.rawValue }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(colors.text.opacity(0.6))
        }
    }
}

//#Preview {
//    ExerciseHeaderView()
//}
