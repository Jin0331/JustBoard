//
//  FollowResponse.swift
//  JustBoard
//
//  Created by JinwooLee on 5/4/24.
//

import Foundation

struct FollowResponse : Decodable {
    let nick : String
    let opponent_nick : String
    let following_status : Bool
}
