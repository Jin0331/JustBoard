//
//  InquiryRequest.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/23/24.
//

import Foundation

struct InquiryRequest {
    let next : String
    let limit : String
    let product_id : String
    
    enum InquiryRequestDefault {
        static let productId = ""
        static let next = "0"
        static let limit = "80"
        static let maxLimit = "9999"
        static let maxPage = 30
    }
}
