//
//  StoryWithProgressModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

struct StoryWithProgress: Identifiable {
    let id: String
    let story: DBStory
    let isLocked: Bool
    let isComplete: Bool
    let currentChapter: Int
}
