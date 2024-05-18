//
//  JoinResponse.swift
//  JustBoard
//
//  Created by JinwooLee on 4/16/24.
//

import Foundation

struct JoinResponse: Decodable {
    let user_id : String
    let email : String
    let nick : String
}
