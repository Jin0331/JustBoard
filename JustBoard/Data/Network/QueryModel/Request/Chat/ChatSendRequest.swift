//
//  ChatSendRequest.swift
//  JustBoard
//
//  Created by JinwooLee on 5/16/24.
//

import Foundation

struct ChatSendRequest : Encodable {
    let content : String
    let files : [String]
}
