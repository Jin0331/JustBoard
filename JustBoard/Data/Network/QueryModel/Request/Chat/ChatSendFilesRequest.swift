//
//  ChatSendFilesRequest.swift
//  JustBoard
//
//  Created by JinwooLee on 5/16/24.
//

import Foundation

struct ChatSendFilesRequest : Encodable {
    let files : [Data]
}
