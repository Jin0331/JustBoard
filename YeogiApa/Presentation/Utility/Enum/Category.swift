//
//  Category.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit

enum CategorySection : CaseIterable {
    case main
}

enum Category : String, CaseIterable {
    case all = "전체"
    case life = "생활꿀팁"
    case concerns = "고민상담"
    case develop = "개발"
    case premises = "부동산"
    case medical = "의료"
    case pill = "약료"
    case law = "법률"
    case pet = "반려동물"
}
