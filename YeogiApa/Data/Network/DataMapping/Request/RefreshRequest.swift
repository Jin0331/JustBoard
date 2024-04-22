//
//  RefreshRequest.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/12/24.
//

import Foundation

struct RefreshRequest : Encodable {
    let accessToken : String
    let refreshToken : String
}
