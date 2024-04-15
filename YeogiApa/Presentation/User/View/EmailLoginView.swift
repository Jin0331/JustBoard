//
//  LoginView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import UIKit
import SnapKit
import Then

final class EmailLoginView : BaseView {
    
    private let headerTextLabel = UILabel().then {
        $0.text = "이메일로 로그인하기 😎"
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
    }
    let userIdTextfield = SignTextField(placeholderText: "이메일")
    let userPasswordTextfield = SignTextField(placeholderText: "비밀번호").then { $0.isSecureTextEntry = true }
    let userLoginButton = NextButton(title: "로그인")
    private let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.spacing = 0
    }
    
    let findEmailButton = UIButton().then {
        $0.setTitle("이메일 찾기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(DesignSystem.commonColorSet.lightBlack, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(DesignSystem.commonColorSet.lightBlack, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    let signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.setTitleColor(DesignSystem.commonColorSet.lightBlack, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    override func configureHierarchy() {
        [headerTextLabel, userIdTextfield, userPasswordTextfield, userLoginButton, buttonStackView].forEach { addSubview($0) }
        [findEmailButton, findPasswordButton, signUpButton].forEach { buttonStackView.addArrangedSubview($0)}
    }
    
    override func configureLayout() {
        
        headerTextLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        userIdTextfield.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(safeAreaInsets).inset(10)
            make.height.equalTo(50)
        }
        
        userPasswordTextfield.snp.makeConstraints { make in
            make.top.equalTo(userIdTextfield.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(userIdTextfield)
            make.height.equalTo(userIdTextfield)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(userPasswordTextfield.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(userIdTextfield).inset(30)
        }
        
        
        userLoginButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(userIdTextfield)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        backgroundColor = DesignSystem.commonColorSet.white
    }
    
    
}
