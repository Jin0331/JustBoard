//
//  SignInUpView.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import Then
import SnapKit

class SignInUpView : BaseView {
    
    private let titleLabel1 = UILabel().then {
        $0.text = "자게?\n자게!"
        $0.numberOfLines = 0
        $0.font = DesignSystem.mainFont.customFontBold(size: 35)
        $0.textColor = DesignSystem.commonColorSet.white
    }
    
    private let titleLabel2 = UILabel().then {
        $0.text = "진짜\n그냥\n자유게시판"
        $0.numberOfLines = 0
        $0.font = DesignSystem.mainFont.customFontHeavy(size: 55)
        $0.textColor = DesignSystem.commonColorSet.white
    }
    
    let appleLoginButton = UIButton().then {
        $0.setTitle(" Apple로 시작하기", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.buttonColorSet.black
        $0.titleLabel?.font = DesignSystem.mainFont.customFontHeavy(size: 20)
        $0.layer.cornerRadius = 12
        $0.setImage(DesignSystem.sfSymbol.appleLogo, for: .normal)
        $0.tintColor = DesignSystem.commonColorSet.white
    }
    
    let emailLoginButton = UIButton().then {
        $0.setTitle("이메일로 시작하기", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.buttonColorSet.black
        $0.titleLabel?.font = DesignSystem.mainFont.customFontHeavy(size: 20)
        $0.layer.cornerRadius = 12
        $0.tintColor = DesignSystem.commonColorSet.white
    }
    
    
    override func configureHierarchy() {
        [titleLabel1, titleLabel2, appleLoginButton, emailLoginButton].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        titleLabel1.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(30)
            make.leading.equalTo(titleLabel1)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-20)
            make.horizontalEdges.equalTo(emailLoginButton)
            make.height.equalTo(60)
        }
        
    }
    
    
    override func configureView() {
        super.configureView()
        backgroundColor = DesignSystem.commonColorSet.lightBlack
    }
    
}

