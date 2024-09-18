//
//  ActionTypeModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-17.
//

import Foundation

enum ActionType: String, Codable {
    case hideText = "hide-text"
    case hideAudio = "hide-audio"
    case emphasizeText = "emphasize-text"
    case hideAll = "hide-all"
}
