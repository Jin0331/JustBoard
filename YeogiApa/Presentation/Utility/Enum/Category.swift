//
//  Category.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit

//MARK: - 실시간 베스트 목록
enum BestCategory : String, CaseIterable  {
    case commentSort = "댓글순 🤔"
    case likeSort = "공감순 👍🏻"
    case unlikeSort = "공감비율순 👎🏻"
    
    var productId : String {
        switch self {
        default :
            return ""
        }
    }
}

//MARK: - 게시판 목록
// questionVC에서 게시판 목록 선택
enum CategorySection : CaseIterable {
    case main
}

enum Category : String, CaseIterable {
    
    case all_test = "전체_테스트"
    case all = "전체"
    case life = "생활꿀팁"
    case concerns = "고민상담"
    case develop = "개발"
    case premises = "부동산"
    case medical = "의료"
    case pill = "약료"
    case law = "법률"
    case pet = "반려동물"
    
    var name : String {
        switch self {
        case .all_test:
            return "all"
        case .all:
            return "all"
        case .life:
            return "life"
        case .concerns:
            return "concerns"
        case .develop:
            return "develop"
        case .premises:
            return "premises"
        case .medical:
            return "medical"
        case .pill:
            return "pill"
        case .law:
            return "law"
        case .pet:
            return "pet"
        }
    }
    
    var productId : String {
        switch self {
        case .all_test:
            return ""
        default :
            return "gyjw_" + self.name
        }
    }
}
