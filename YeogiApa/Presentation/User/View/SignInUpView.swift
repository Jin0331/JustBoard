//
//  SignInUpView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import Then
import SnapKit

class SignInUpView : BaseView {
    
    private let titleLabel1 = UILabel().then {
        $0.text = "어디 아플 때\n누구에게\n물어보지?"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textColor = DesignSystem.commonColorSet.white
    }
    
    private let titleLabel2 = UILabel().then {
        $0.text = "여기아파"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 55, weight: .heavy)
        $0.textColor = DesignSystem.commonColorSet.white
    }
    
    private let kakaoLoginButton = UIButton().then {
        $0.setTitle("카카오로 시작하기", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.black, for: .normal)
        $0.backgroundColor = DesignSystem.buttonColorSet.yellow
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.layer.cornerRadius = 12
        $0.setImage(UIImage(named: "kakaotalk_sharing_btn_small_ov"), for: .normal)
    }
    
    private let appleLoginButton = UIButton().then {
        $0.setTitle(" Apple로 시작하기", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.buttonColorSet.black
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.layer.cornerRadius = 12
        $0.setImage(DesignSystem.sfSymbol.appleLogo, for: .normal)
        $0.tintColor = DesignSystem.commonColorSet.white
    }
    
    private let emailLoginButton = UIButton().then {
        $0.setTitle("이메일 로그인 ", for: .normal)
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.buttonColorSet.clear
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }

    
    override func configureHierarchy() {
        [titleLabel1, titleLabel2, kakaoLoginButton, appleLoginButton, emailLoginButton].forEach { addSubview($0)}
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
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(30)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(emailLoginButton.snp.top).offset(-20)
            make.horizontalEdges.equalTo(emailLoginButton)
            make.height.equalTo(60)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-20)
            make.horizontalEdges.equalTo(emailLoginButton)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = DesignSystem.commonColorSet.lightBlack
    }
    
}

