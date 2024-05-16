//
//  PostRequest.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation

struct PostRequest : Encodable {
    let product_id : String
    let title : String
    let content1 : String // 본문
    let content2 : String // 링크
    let content3 : String // 이미지 position
    let files : [String] // 이미지
}
