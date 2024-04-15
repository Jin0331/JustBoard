//
//  SignUpPasswordViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/16/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol SignUpPasswordViewControllerDelegate {
    func netxSignUpProfileVC(email : String)
}

final class SignUpPasswordViewController: RxBaseViewController {
    
    private let headerTextLabel = UILabel().then {
        $0.text = "비밀번호를 입력해주세요 😎"
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
    }
    
    private let headerSubTextLabel = UILabel().then {
        $0.text = "한 개 이상의 대/소문자 영문, 숫자, 특수문자(.@$!%*?&)를\n조합하여 8~15자리로 작성해주세요"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    
    private let passwordTextfield = SignTextField(placeholderText: "비밀번호").then {
        $0.isSecureTextEntry = true
    }
    
    private let passwordVerfyTextfield = SignTextField(placeholderText: "비밀번호 확인").then {
        $0.isSecureTextEntry = true
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.commonColorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
        $0.setTitleColor(DesignSystem.commonColorSet.white, for: .normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        
    }

    override func configureHierarchy() {
        [headerTextLabel, headerSubTextLabel, passwordTextfield, passwordVerfyTextfield, nextButton].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        headerTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        headerSubTextLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(headerTextLabel)
            make.height.equalTo(50)
        }
        
        passwordTextfield.snp.makeConstraints { make in
            make.top.equalTo(headerSubTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        passwordVerfyTextfield.snp.makeConstraints { make in
            make.top.equalTo(passwordTextfield.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(passwordVerfyTextfield.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(passwordTextfield)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
}


