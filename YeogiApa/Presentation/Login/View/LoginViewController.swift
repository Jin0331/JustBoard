//
//  LoginViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class LoginViewController: RxBaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
     
    }
    
    override func bind() {
        let input = LoginViewModel.Input(email: mainView.userIdTextfield.rx.text.orEmpty,
                                         password: mainView.userPasswordTextfield.rx.text.orEmpty,
                                         loginButtonTap: mainView.userLoginButton.rx.tap)
        
        let output = viewModel.transform(input: input)
    }
    
    
    // 테스트용 삭제해야됨 ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️
    @objc func profileButtonClicked() {
        print(#function)
        
        let url = URL(string: APIKey.baseURL.rawValue + "v1/users/me/profile")!
        guard let accessToken = UserDefaultManager.shared.accessToken else { return print("???")}
        let headers : HTTPHeaders = [
            HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue,
            HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
            HTTPHeader.authorization.rawValue : accessToken
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers, interceptor: AuthManager())
        .responseDecodable(of: ProfileResponse.self) { response in
            switch response.result {
            case .success(let value):
                print("프로필 조회 성공\n\(value)")
            case .failure(let error):
                print(response.response?.statusCode)
                print("프로필 조회 실패 : \(error)")
            }
        }
    }
    
}
