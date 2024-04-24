//
//  DiffableDataSource+Typealias.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import Foundation
import UIKit

enum BoardViewSection : CaseIterable {
    case main
}


typealias BoardDataSource = UICollectionViewDiffableDataSource<BoardViewSection, PostResponse>
typealias BoardDataSourceSnapshot = NSDiffableDataSourceSnapshot<BoardViewSection, PostResponse>
