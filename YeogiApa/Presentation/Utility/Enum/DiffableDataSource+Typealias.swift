//
//  DiffableDataSource+Typealias.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import Foundation
import UIKit

//MARK: - BoardView
enum BoardViewSection : CaseIterable {
    case main
}


typealias BoardDataSource = UICollectionViewDiffableDataSource<BoardViewSection, PostResponse>
typealias BoardDataSourceSnapshot = NSDiffableDataSourceSnapshot<BoardViewSection, PostResponse>
typealias BoardCellRegistration = UICollectionView.CellRegistration<BoardCollectionViewCell, PostResponse>


//MARK: - BoardDetailView
enum BoardDetailViewSection : CaseIterable {
    case main
}

typealias BoardDetailDataSource = UICollectionViewDiffableDataSource<BoardDetailViewSection, Comment>
typealias BoardDetailDataSourceSnapshot = NSDiffableDataSourceSnapshot<BoardDetailViewSection, Comment>
typealias BoardDetailCellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, Comment>


