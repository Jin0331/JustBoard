//
//  BoardMainView.swift
//  JustBoard
//
//  Created by JinwooLee on 4/30/24.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import Reusable
import Tabman
import Pageboy

final class BoardMainView: BaseView {
    let tabmanVC : TabmanViewController
    let tabmanUserVC : TabmanViewController
    
    let menuBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.list?.withRenderingMode(.alwaysOriginal)).then {
        $0.tintColor = DesignSystem.commonColorSet.black
    }
    
    let dmBarButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.dm?.withRenderingMode(.alwaysOriginal)).then {
        $0.tintColor = DesignSystem.commonColorSet.black
    }
    
    init(tabmanVC: TabmanViewController, tabmanUserVC: TabmanViewController) {
        self.tabmanVC = tabmanVC
        self.tabmanUserVC = tabmanUserVC
        super.init(frame: .zero)
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.lightGray
    }
    
    let movewToAllBoard = CompleteButton(title: "", image: nil, fontSize: 17).then {
        $0.layer.cornerRadius = 0
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let boardRankLabel = CommonLabel(title: "실시간 Best 20", fontSize: 18)
    let boardPostRankLabel = CommonLabel(title: "실시간 게시글 순위", fontSize: 18)
        
    override func configureHierarchy() {
        
        [scrollView].forEach { addSubview($0) }
        scrollView.addSubview(contentsView)
        
        [boardRankLabel, tabmanUserVC.view, boardPostRankLabel, tabmanVC.view, movewToAllBoard].forEach { contentsView.addSubview($0)}
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        boardRankLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        tabmanUserVC.view.snp.makeConstraints { make in
            make.top.equalTo(boardRankLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(350)
        }
        
        boardPostRankLabel.snp.makeConstraints { make in
            make.top.equalTo(tabmanUserVC.view.snp.bottom)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        tabmanVC.view.snp.makeConstraints { make in
            make.top.equalTo(boardPostRankLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(2250)
        }
        
        movewToAllBoard.snp.makeConstraints { make in
            make.top.equalTo(tabmanVC.view.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(tabmanVC.view)
            make.height.equalTo(10)
            make.bottom.equalToSuperview()
        }
    }
}
