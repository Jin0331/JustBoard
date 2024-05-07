//
//  CategorySelectView.swift
//  JustBoard
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit
import Then
import SnapKit

final class CategorySelectView: BaseView {

    private let titleLabel = UILabel().then {
        $0.text = "🔆 분야 선택하기"
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
    }
    
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(mainCollectionView)
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).offset(30)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            }
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
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
