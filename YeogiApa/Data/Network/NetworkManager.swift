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
    
    
    //TODO: - 현재 성공 case만 테스트됨, error 처리 필요함
    func createLogin(query: LoginRequest) -> Single<LoginResponse> {
        return Single<LoginResponse>.create { single in
            do {
                let urlRequest = try UserRouter.login(query: query).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(loginModel))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}

//MARK: - Access Token 갱신을 위한 Alamorefire RequestInterceptor protocol
final class AuthManager : RequestInterceptor {
 
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        // Token이 없는 상황, 즉 로그인을 새롭게 시도하는 상황
        guard let accessToken = UserDefaultManager.shared.accessToken, let refreshToken = UserDefaultManager.shared.refreshToken else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(name: HTTPHeader.authorization.rawValue, value: accessToken)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        // 419 : AccessToken 만료
        //TODO: - 401 이 발생할 가능성이 있을까??? -> 서버가 리셋 즉, 회원가입이 안 된 유저
        //MARK: - 아래의 코드(do 시작전까지)는 필요하지 않을 듯????/
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            print("Token Refresh Fail : \(error)")
            
            completion(.doNotRetryWithError(error))
            return
        }
        
        // adpat -> retry이므로, UserDefault에는 Token값이 무조건 존재
        do {
            let urlRequest = try UserRouter.refresh(query: RefreshRequest(accessToken: UserDefaultManager.shared.accessToken!,
                                                                          refreshToken: UserDefaultManager.shared.refreshToken!))
                .asURLRequest()
            
            // refresh
            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RefreshResponse.self) { response in
                    switch response.result {
                    case .success(let refreshResponse): // Token이 Refresh 성공했을 때
                        print("Token Refresh Success")
                        
                        UserDefaultManager.shared.accessToken = refreshResponse.accessToken
                        completion(.retryWithDelay(10))
                    case .failure(let error): // Token이 Refresh 실패했을 때,, refreshToken이 만료되었거나(418), 비정상적인 접근(401, 403)
                        print("Token Refresh Fail : \(error)")
                        
                        UserDefaultManager.shared.accessToken = nil
                        UserDefaultManager.shared.refreshToken = nil
                        completion(.doNotRetryWithError(error))
                    }
                }
        } catch { } // 어떤 에러가 발생할 수 있을까....?
        
    }
}