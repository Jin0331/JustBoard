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
    
    //MARK: - Join
    
    func createJoin(query : JoinRequest) -> Single<Result<JoinResponse, AFError>>  {
        return Single<Result<JoinResponse, AFError>>.create  { single in
            do {
                let urlRequest = try UserRouter.join(query: query).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: JoinResponse.self) { response in
                        switch response.result {
                        case .success(let joinResponse):
                            single(.success(.success(joinResponse)))
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
    
    //MARK: - Login
    func createLogin(query: LoginRequest) -> Single<Result<LoginResponse, AFError>> {
        return Single<Result<LoginResponse, AFError>>.create { single in
            do {
                let urlRequest = try UserRouter.login(query: query).asURLRequest()
                                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: LoginResponse.self) { response in
                        switch response.result {
                        case .success(let loginResponse):
                            single(.success(.success(loginResponse)))
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
    
    //MARK: - Post FileUpload
    func post(query : FilesRequest, category : String) -> Single<Result<FilesResponse, AFError>> {
        return Single<Result<FilesResponse, AFError>>.create { single in
                
            let router =  MainRouter.files(query: query, category: category)
            let url = router.baseURL.appendingPathComponent(router.path).absoluteString.removingPercentEncoding!
            let header = HTTPHeaders(router.header)
            
            print(url, header, router.multipart, "🤔")

            AF.upload(multipartFormData: router.multipart, to: url, headers: header, interceptor: AuthManager())
                .responseDecodable(of: FilesResponse.self) { response in
                    switch response.result {
                    case .success(let filesResponse):
                        print(filesResponse)
                        single(.success(.success(filesResponse)))
                    case .failure(let error):
                        print(response.response?.statusCode)
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: - Post
//    func post(query : WriteRequest) -> Single<Result<String, AFError>> {
//        return Single<Result<String, AFError>>.create { single in
//            do {
//                let urlRequest = try UserRouter.emailValidation(query: query).asURLRequest()
//                
//                AF.request(urlRequest)
//                    .validate(statusCode: 200..<300)
//                    .responseData { response in
//                        switch response.result {
//                        case .success:
//                            single(.success(.success(query.email)))
//                        case .failure(let error):
//                            single(.success(.failure(error)))
//                        }
//                    }
//                
//            } catch {
//                single(.failure(error))
//            }
//            return Disposables.create()
//        }
//    }
}
