//
//  DiffableDataSource+Typealias.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit

//MARK: - Menu
enum MenuViewSection : CaseIterable {
    case main
}

enum MenuCase : String, CaseIterable {
    case home = "홈으로 돌아가기"
    case myProfile = "내 프로필 조회하기"
    case latest = "최근 본 글 조회하기"
    
    var iconImage : UIImage? {
        switch self {
        case .home:
            return DesignSystem.sfSymbol.home
        case .myProfile:
            return DesignSystem.sfSymbol.profile
        case .latest:
            return DesignSystem.sfSymbol.latest
        }
    }
}

//MARK: - BoardDetailView
enum BoardDetailViewSection : CaseIterable {
    case main
}
typealias MenuDataSource = UICollectionViewDiffableDataSource<MenuViewSection, MenuCase>
typealias MenuDataSourceSnapshot = NSDiffableDataSourceSnapshot<MenuViewSection, MenuCase>
typealias MenuCellRegistration = UICollectionView.CellRegistration<MenuCollectionViewCell, MenuCase>


typealias BoardDetailDataSource = UICollectionViewDiffableDataSource<BoardDetailViewSection, Comment>
typealias BoardDetailDataSourceSnapshot = NSDiffableDataSourceSnapshot<BoardDetailViewSection, Comment>
typealias BoardDetailCellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, Comment>


