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
    
    let completeButtonItem = UIBarButtonItem().then {
        $0.title = "작성하기"
        $0.tintColor = DesignSystem.commonColorSet.gray
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .heavy)
        ]
        $0.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.bounces = false
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    private let categoryTitleLabel = UILabel().then {
        $0.text = "분야를 선택하고 글을 작성해주세요"
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
    
    let titleTextField = STTextView().then {
                
        $0.font = .systemFont(ofSize: 25, weight: .heavy)
        $0.placeholderVerticalAlignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .bold), // Set the desired font size
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 게시글의 제목을 입력해보세요", attributes: attributes)
    }
    
    let contentsTextView = STTextView().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), // Set the desired font size
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 게시글의 본문을작성해주세요.", attributes: attributes)
        $0.placeholderVerticalAlignment = .center
        $0.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private let stackBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 3
    }
    
    let imageAddButton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.photo, for: .normal)
        $0.tintColor = DesignSystem.commonColorSet.black
    }
    
    let linkAddButton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.link, for: .normal)
        $0.tintColor = DesignSystem.commonColorSet.black
    }
    
    private let brView1 = DelimiterLine()
    private let brView2 = DelimiterLine()
    
    override func configureHierarchy() {
        [scrollView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentsView)
        
        [categoryTitleLabel, categorySelectButton, brView1, titleTextField, brView2, stackBackgroundView, contentsTextView].forEach { contentsView.addSubview($0) }
        
        stackBackgroundView.addSubview(buttonStackView)
        
        [imageAddButton,linkAddButton].forEach{buttonStackView.addArrangedSubview($0)}
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        categoryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        categorySelectButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(categoryTitleLabel)
            make.height.equalTo(60)
        }
        
        brView1.snp.makeConstraints { make in
            make.top.equalTo(categorySelectButton.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(10)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(brView1.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        brView2.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(10)
        }
        
        stackBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(brView2.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.verticalEdges.equalToSuperview()
            make.width.equalTo(80)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.top.equalTo(stackBackgroundView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
            make.bottom.equalToSuperview()
        }
    }
    
    func contentsTextViewUIUpdate() {
        contentsTextView.font = .systemFont(ofSize: 21, weight: .heavy)
    }
    
}
