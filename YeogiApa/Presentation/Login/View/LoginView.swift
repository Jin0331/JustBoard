//
//  LoginView.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import UIKit
import SnapKit
import Then

final class LoginView : BaseView {
    
    private let headerTextLabel = UILabel().then {
        $0.text = "로그인/회원가입"
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
    }
    
    let userIdTextfield = UITextField().then {
        $0.placeholder = "아이디"
    }
    
    let userPasswordTextfield = UITextField().then {
        $0.placeholder = "비밀번호"
    }
    
    let userLoginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.backgroundColor = DesignSystem.colorSet.black
        $0.layer.cornerRadius = DesignSystem.cornerRadius.commonCornerRadius
    }
    
    //MARK: - 갱신용 버튼. 삭제필요 ❗️❗️❗️❗️❗️❗️❗️❗️❗️
    lazy var profileButton = UIButton().then {
        $0.setTitle("프로필 조회", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    
    
    override func configureHierarchy() {
        [headerTextLabel, userIdTextfield, userPasswordTextfield, userLoginButton, profileButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        headerTextLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(80)
            make.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        userIdTextfield.snp.makeConstraints { make in
            make.top.equalTo(headerTextLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaInsets).inset(10)
            make.height.equalTo(60)
        }
        
        userPasswordTextfield.snp.makeConstraints { make in
            make.top.equalTo(userIdTextfield.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(userIdTextfield)
            make.height.equalTo(userIdTextfield)
        }
        
        userLoginButton.snp.makeConstraints { make in
            make.top.equalTo(userPasswordTextfield.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(userIdTextfield).inset(10)
            make.height.equalTo(userIdTextfield)
        }
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(userLoginButton.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(userIdTextfield).inset(10)
            make.height.equalTo(userIdTextfield)
        }
        
    }
    
    
}
