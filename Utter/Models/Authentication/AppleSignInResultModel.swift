//
//  AppleSignInResultModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-18.
//

import Foundation

struct AppleSignInResultModel {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}
