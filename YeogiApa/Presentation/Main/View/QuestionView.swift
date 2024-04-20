//
//  QuestionView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit
import Then
import SnapKit
import STTextView

final class QuestionView: BaseView {
    
    let searchButtonItem = UIBarButtonItem().then {
        $0.title = "질문하기"
        $0.tintColor = DesignSystem.commonColorSet.gray
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)
        ]
        $0.setTitleTextAttributes(attributes, for: .normal)
        
    }
    
    private let categoryTitleLabel = UILabel().then {
        $0.text = "분야를 선택하고 질문을 작성해주세요"
        $0.textColor = DesignSystem.commonColorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    let categorySelectButton = UIButton().then {
        $0.setTitle("분야 선택하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        $0.titleLabel?.textAlignment = .left
        $0.setTitleColor(DesignSystem.commonColorSet.black, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.lightGray
        $0.layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystem.commonColorSet.gray.cgColor
    }
    
    private let brView1 = DelimiterLine()
    
    let titleTextField = STTextView().then {
                
        $0.font = .systemFont(ofSize: 25, weight: .heavy)
        $0.placeholderVerticalAlignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold), // Set the desired font size
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 물음표로 끝나는 제목을 입력해보세요", attributes: attributes)
    }
    
    private let brView2 = DelimiterLine()
    
    let contentsTextView = STTextView().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), // Set the desired font size
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 궁금한 점을 자세하게 작성해주세요.\n-구체적이고 명료한 질문으로 작성해주세요.", attributes: attributes)
        $0.placeholderVerticalAlignment = .center
        $0.textContainerInset = .init(top: 1, left: 10, bottom: 10, right: 10)
    }
    
    override func configureHierarchy() {
        [categoryTitleLabel, categorySelectButton, brView1, titleTextField, brView2, contentsTextView].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        categorySelectButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(categoryTitleLabel)
            make.height.equalTo(60)
        }
        
        brView1.snp.makeConstraints { make in
            make.top.equalTo(categorySelectButton.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(15)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(brView1.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        brView2.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(15)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(brView2.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
    }
    
}
