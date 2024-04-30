//
//  RxDataSource+Typealias.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/29/24.
//

import RxDataSources

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
