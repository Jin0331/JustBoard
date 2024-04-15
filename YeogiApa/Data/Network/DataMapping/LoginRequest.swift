//
//  LoginRequest.swift
//  LSLPBasic
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation

// HTTP POST
struct LoginRequest : Encodable {
    let email : String
    let password : String
}
