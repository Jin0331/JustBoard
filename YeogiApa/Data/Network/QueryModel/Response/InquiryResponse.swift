//
//  InquiryResponse.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/23/24.
//

import Foundation

struct InquiryResponse : Decodable {
    let data : [WriteResponse]
    let next_cursor : String
}
