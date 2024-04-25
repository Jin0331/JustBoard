//
//  LinkViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/22/24.
//

import UIKit
import Then
import SnapKit
import STTextView
import RxSwift
import RxCocoa

class LinkViewController: RxBaseViewController {

    private let titleLabel = UILabel().then {
        $0.text = "🔗 유튜브 링크 첨부하기"
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
    }
    private let urlLinkTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold), // Set the desired font size
            NSAttributedString.Key.foregroundColor: DesignSystem.commonColorSet.gray
        ]
        $0.attributedPlaceholder = NSAttributedString(string: " URL 링크를 입력해주세요", attributes: attributes)
    }
    private let addButton = CompleteButton(title: "첨부", image: DesignSystem.sfSymbol.link, fontSize: 18, disable: true)
    private let brView = DelimiterLine()
    
    var sendData : ((String) -> ())?
    
    override func bind() {
        
        let addSuccess = PublishSubject<Bool>()
        
        urlLinkTextField.rx.text.orEmpty
            .bind(with: self) { owner, text in
                addSuccess.onNext(owner.isValidURL(text))
            }
            .disposed(by: disposeBag)
        
        addSuccess
            .bind(with: self) { owner, bool in
                owner.addButton.isEnabled = bool
                owner.addButton.alpha = bool ? 1.0 : 0.5
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withLatestFrom(urlLinkTextField.rx.text.orEmpty)
            .bind(with: self) { owner, link in
                owner.sendData?(link)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    override func configureHierarchy() {
        [titleLabel, urlLinkTextField, addButton, brView].forEach { view.addSubview($0)}
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        urlLinkTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(40)
            make.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(urlLinkTextField)
            make.trailing.equalTo(titleLabel)
            make.height.equalTo(urlLinkTextField)
            make.width.equalTo(80)
        }
        
        brView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(5)
        }
        
        
    }
    
    override func configureView() {
        super.configureView()
        view.backgroundColor = .white
    }
    
    private func isValidURL(_ urlString: String) -> Bool {
        // URL 정규표현식 패턴
        let urlRegex = #"((http|https)://)((\w|\.)+)(/\w+)?"#
        
        // 정규표현식과 매치되는지 확인
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegex)
        return urlTest.evaluate(with: urlString)
    }

}
