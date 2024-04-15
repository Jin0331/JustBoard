//
//  NetworkManager.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkManager  {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    //MARK: - Login
    func createLogin(query: LoginRequest) -> Single<Result<LoginResponse, AFError>> {
        return Single<Result<LoginResponse, AFError>>.create { single in
            do {
                let urlRequest = try UserRouter.login(query: query).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(.success(loginModel)))
                        case .failure(let error):
                            print(response.response?.statusCode)
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    //MARK: - Email validation
    func validationEmail(query : EmailValidationRequest) -> Single<Result<String, AFError>> {
        return Single<Result<String, AFError>>.create { single in
            do {
                let urlRequest = try UserRouter.emailValidation(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseData { response in
                        switch response.result {
                        case .success:
                            single(.success(.success(query.email)))
                        case .failure(let error):
                            single(.success(.failure(error)))
                        }
                    }
                
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
