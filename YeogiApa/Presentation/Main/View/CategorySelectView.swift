//
//  CategorySelectView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit
import Then
import SnapKit

final class CategorySelectView: BaseView {

    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    override func configureHierarchy() {
        addSubview(mainCollectionView)
    }
    
    override func configureLayout() {
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = DesignSystem.commonColorSet.white
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    func periodSelectCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Category> {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Category> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier.rawValue
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = DesignSystem.commonColorSet.white
            
            cell.backgroundConfiguration = background
        }
        
        return cellRegistration
    }
}
