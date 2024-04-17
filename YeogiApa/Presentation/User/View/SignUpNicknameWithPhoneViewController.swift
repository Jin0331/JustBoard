//
//  SignUpNicknameWithPhoneViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/16/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class SignUpNicknameWithPhoneViewController: RxBaseViewController {

    //TODO: - 전화번호는 나중에 인증 기능추가되면 구현?
    private let headerTextLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요 😎"
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
    }
    private let headerSubTextLabel = UILabel().then {
        $0.text = "사용할 닉네임을 띄어쓰기 없이 4~8자 이내로 입력해주세요"
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.textColor = DesignSystem.commonColorSet.gray
    }
    private let nicknameTextfield = SignTextField(placeholderText: "닉네임")
    private let completeButton = NextButton(title: "회원가입 완료")
    
    var viewModel : SignUpNicknameWithPhoneViewModel
    weak var delegate : EmailLoginCoordinator?
    
    init(email : String, password : String) {
        self.viewModel = SignUpNicknameWithPhoneViewModel(email: email, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = SignUpNicknameWithPhoneViewModel.Input(nickname: nicknameTextfield.rx.text.orEmpty,
                                                           completeButtonTap: completeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        output.completeButtonUIUpdate
            .drive(with: self) { owner, value in
                owner.completeButton.isEnabled = value
                owner.completeButton.alpha = value ? 1.0 : 0.5
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [headerTextLabel, headerSubTextLabel, nicknameTextfield, completeButton].forEach { view.addSubview($0) }
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
        
        nicknameTextfield.snp.makeConstraints { make in
            make.top.equalTo(headerSubTextLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextfield.snp.bottom).offset(80)
            make.horizontalEdges.equalTo(nicknameTextfield)
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        view.backgroundColor = DesignSystem.commonColorSet.white
    }
    
    
}
