//
//  QuestionView.swift
//  JustBoard
//
//  Created by JinwooLee on 4/20/24.
//

import UIKit
import Then
import SnapKit
import STTextView

final class QuestionView: BaseView {
    
    let completeButtonItem = CompleteButton(title: "등록", image: nil, fontSize: 18, disable: false).then {
        $0.frame = CGRect(x: 0, y: 0, width: 70, height: 35)
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

    let titleTextField = STTextView().then {
        $0.font = DesignSystem.mainFont.customFontHeavy(size: 25)
        $0.textColor = DesignSystem.commonColorSet.black
        $0.backgroundColor = DesignSystem.commonColorSet.white
        $0.placeholderVerticalAlignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: DesignSystem.mainFont.customFontBold(size: 21),
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 게시글의 제목을 입력해보세요", attributes: attributes)
    }
    
    let contentsTextView = STTextView().then {
        $0.font = DesignSystem.mainFont.customFontSemiBold(size: 21)
        $0.textColor = DesignSystem.commonColorSet.black
        $0.backgroundColor = DesignSystem.commonColorSet.white
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: DesignSystem.mainFont.customFontSemiBold(size: 17),
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " 게시글의 본문을 작성해주세요.", attributes: attributes)
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
        
        [brView1, titleTextField, brView2, stackBackgroundView, contentsTextView].forEach { contentsView.addSubview($0) }
        
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
        
        brView1.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
            make.height.equalTo(UIScreen.main.bounds.height / 2.5)
            make.bottom.equalToSuperview()
        }
    }
    
    func contentsTextViewUIUpdate() {
        contentsTextView.font = DesignSystem.mainFont.customFontHeavy(size: 21)
    }
    
    override func configureView() {
        backgroundColor = DesignSystem.commonColorSet.white
    }
    
}
