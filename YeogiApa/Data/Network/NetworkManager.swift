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
    //TODO: - 제네릭 구조로 변경 필요
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
                            print(response.response?.statusCode as Any)
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
                        print(response.response?.statusCode as Any, error, "✅ NetworkManager - post(query : FilesRequest, category : String)")
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    //MARK: - Post
    // Post 작성
    func post(query : PostRequest) -> Single<Result<PostResponse, AFError>> {
        return Single<Result<PostResponse, AFError>>.create { single in
            do {
                let urlRequest = try MainRouter.write(query: query).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostResponse.self) { response in
                        switch response.result {
                        case .success(let writeResponse):
                            single(.success(.success(writeResponse)))
                        case .failure(let error):
                            print(response.response?.statusCode as Any, error, "✅ NetworkManager - post(query : PostRequest)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    // Post 조회
    func post(query : InquiryRequest) -> Single<Result<InquiryResponse, AFError>> {
        return Single<Result<InquiryResponse, AFError>>.create { single in
            do {
                let urlRequest = try MainRouter.inquiry(query: query).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: InquiryResponse.self) { response in
                        switch response.result {
                        case .success(let inquiryResponse):
                            single(.success(.success(inquiryResponse)))
                        case .failure(let error):
                            print(response.response?.statusCode as Any, error, "✅ NetworkManager - post(query : InquiryRequest)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // Post 조회 - 특정
    func post(postId : String) -> Single<Result<PostResponse, AFError>> {
        return Single<Result<PostResponse, AFError>>.create { single in
            do {
                let urlRequest = try MainRouter.specificInquiry(postId: postId).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: PostResponse.self) { response in
                        switch response.result {
                        case .success(let inquiryResponse):
                            single(.success(.success(inquiryResponse)))
                        case .failure(let error):
                            print(response.response?.statusCode as Any, error, "✅ NetworkManager - post(postId : String)")
                            single(.success(.failure(error)))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    //MARK: - Comment
    func comment(query : CommentRequest, postId : String) -> Single<Result<Comment, AFError>> {
        
        return Single<Result<Comment, AFError>>.create { single in
            do {
                let urlRequest = try MainRouter.comment(query: query, postId: postId).asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: Comment.self) { response in
                        switch response.result {
                        case .success(let commentResponse):
                            single(.success(.success(commentResponse)))
                        case .failure(let error):
                            print(response.response?.statusCode as Any, error, "✅ NetworkManager - comment")
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
