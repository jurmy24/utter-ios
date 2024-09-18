//
//  StoryViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

@MainActor
final class StoryViewModel: ObservableObject {
    //    @Published var blocks:
//    @Published var jsonData = nil
    @Published var storyString: String = ""
    
    func loadStory(path: String) async throws {
        let data = try await StorageManager.shared.getStory(path: path)
        self.storyString = String(data: data, encoding: .utf8) ?? "It didn't work"
    }
}
