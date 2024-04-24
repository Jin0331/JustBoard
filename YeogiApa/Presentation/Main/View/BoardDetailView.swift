//
//  BoardDetailView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import UIKit
import Then
import SnapKit

final class BoardDetailView: BaseView {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
    }
    
    private let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let title = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.text = "[일반] 노엘 : 작년에 30만정도에 이어폰 샀는데 소리가 좋더라 시파파파파파ㅏ파파파파파파파파파파"
        $0.numberOfLines = 2
    }
    
    let author = UIButton().then {
        $0.setTitle("가영짱짱", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let createdAt = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    let commentCountButton = CompleteButton(title: "0", image: nil, fontSize: 16, disable: false).then {
        $0.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
    }
    
    let mainTextView = UITextView().then {
        $0.isEditable = false
    }
    
    override func configureHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentsView)
        [title, author, createdAt, commentCountButton, mainTextView].forEach { contentsView.addSubview($0) }
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(contentsView)
            make.height.greaterThanOrEqualTo(70)
        }
        
        author.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalTo(title)
        }
        
        commentCountButton.snp.makeConstraints { make in
            make.centerY.equalTo(author)
            make.height.equalTo(author)
            make.width.equalTo(80)
        }
        
        mainTextView.snp.makeConstraints { make in
            make.top.equalTo(commentCountButton.snp.bottom).offset(10)
            make.width.equalTo(contentsView)
            make.height.greaterThanOrEqualTo(50)
            make.bottom.equalToSuperview().inset(20)
        }
    }

}
