//
//  SignUpViewController.swift
//  JustBoard
//
//  Created by JinwooLee on 4/15/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


final class SignUpEmailViewController: RxBaseViewController {
    
    private let headerTextLabel = UILabel().then {
        $0.text = "이메일을 입력해주세요 😎"
        $0.font = DesignSystem.mainFont.customFontHeavy(size: 30)
        $0.textColor = DesignSystem.commonColorSet.black
    }
    private let headerSubTextLabel = UILabel().then {
        $0.text = "로그인 시 사용할 이메일을 입력해주세요"
        $0.font = DesignSystem.mainFont.customFontHeavy(size: 15)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    private let emailTextfield = SignTextField(placeholderText: "이메일")
    private let nextButton = NextButton(title: "다음")
    
    let viewModel = SignUpEmailViewModel()
    weak var parentCoordinator : EmailLoginCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = SignUpEmailViewModel.Input(email: emailTextfield.rx.text.orEmpty,
                                               nextButtonTap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        output.nextButtonUIUpdate
            .drive(with: self) { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.alpha = value ? 1.0 : 0.5
            }
            .disposed(by: disposeBag)
        
        output.validEmail
            .drive(with: self) { owner, email in
                owner.parentCoordinator?.netxSignUpPasswordVC(email:email)
            }
            .disposed(by: disposeBag)
        
        output.nextFailed
            .drive(with: self) { owner, value in
                print("로그인 실패", value)
                owner.showAlert(title: "이메일 중복", text: "이미 등록된 이메일입니다 🥲", addButtonText: "확인")
            }
            .disposed(by: disposeBag)
        
    }

    override func configureHierarchy() {
        [headerTextLabel, headerSubTextLabel, emailTextfield, nextButton].forEach { view.addSubview($0) }
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
        
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(headerSubTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(emailTextfield)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
}
