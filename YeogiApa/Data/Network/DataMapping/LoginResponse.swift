//
//  LoginResponse.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
