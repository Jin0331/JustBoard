//
//  WriteRequest.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation

struct WriteRequest : Encodable {
    let title : String
    let content : String
    let product_id : String
}
