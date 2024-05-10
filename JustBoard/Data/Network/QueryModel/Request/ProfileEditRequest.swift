//
//  ProfileEditRequest.swift
//  JustBoard
//
//  Created by JinwooLee on 5/9/24.
//

import Foundation

struct ProfileEditRequest : Encodable {
    let nick : String
    let profile : Data
}
