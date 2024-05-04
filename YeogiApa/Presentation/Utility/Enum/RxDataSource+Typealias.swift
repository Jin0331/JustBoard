//
//  RxDataSource+Typealias.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/29/24.
//

import RxDataSources

//MARK: - BoardMain - 실시간 게시판 순위
struct BoardRankDataSection {
    var items: [(postRank:PostRank, userRank:UserRank)]
}

extension BoardRankDataSection: SectionModelType {
    typealias Item = (postRank:PostRank, userRank:UserRank)
    
    init(original: BoardRankDataSection, items: [(postRank:PostRank, userRank:UserRank)]) {
        self = original
        self.items = items
    }
}

typealias BoardRankRxDataSource = RxCollectionViewSectionedReloadDataSource<BoardRankDataSection>


//MARK: - BoardMain - 실시간 게시글 순위
struct BoardDataSection {
    var items: [PostResponse]
}

extension BoardDataSection: SectionModelType {
    typealias Item = PostResponse
    
    init(original: BoardDataSection, items: [PostResponse]) {
        self = original
        self.items = items
    }
}

typealias BoardRxDataSource = RxCollectionViewSectionedReloadDataSource<BoardDataSection>


//MARK: - Follow
struct FollowDataSection {
    var items: [ProfileResponse]
}

extension FollowDataSection: SectionModelType {
    typealias Item = ProfileResponse
    
    init(original: FollowDataSection, items: [ProfileResponse]) {
        self = original
        self.items = items
    }
}

typealias FollowRxDataSource = RxCollectionViewSectionedReloadDataSource<FollowDataSection>
