//
//  NetworkManager.swift
//  JustBoard
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import RxSwift
import Alamofire

final class NetworkManager  {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    private func userMakeRequest<T: Decodable>(router: URLRequestConvertible) -> Single<Result<T, AFError>> {
        return Single<Result<T, AFError>>.create { single in
            do {
                
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
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
    
    private func mainMakeRequest<T: Decodable>(router: URLRequestConvertible) -> Single<Result<T, AFError>> {
        return Single<Result<T, AFError>>.create { single in
            do {
                
                let urlRequest = try router.asURLRequest()
                
                AF.request(urlRequest, interceptor: AuthManager())
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let data):
                            single(.success(.success(data)))
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
    
    //MARK: - User
    func createJoin(query: JoinRequest) -> Single<Result<JoinResponse, AFError>> {
        return userMakeRequest(router: UserRouter.join(query: query))
    }
    
    func createLogin(query: LoginRequest) -> Single<Result<LoginResponse, AFError>> {
        return userMakeRequest(router: UserRouter.login(query: query))
    }
    
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
    
    //MARK: - Main
    func post(query: FilesRequest, category: String) -> Single<Result<FilesResponse, AFError>> {
        let router = MainRouter.files(query: query, category: category)
        let url = router.baseURL.appendingPathComponent(router.path).absoluteString.removingPercentEncoding!
        let header = HTTPHeaders(router.header)
        let method = router.method
        
        return Single<Result<FilesResponse, AFError>>.create { single in
            AF.upload(multipartFormData: router.multipart, to: url, method: method, headers: header, interceptor: AuthManager())
                .responseDecodable(of: FilesResponse.self) { response in
                    switch response.result {
                    case .success(let filesResponse):
                        single(.success(.success(filesResponse)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func post(query: PostRequest) -> Single<Result<PostResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.write(query: query))
    }
    
    func post(query: InquiryRequest) -> Single<Result<InquiryResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.inquiry(query: query))
    }
    
    func post(postId: String) -> Single<Result<PostResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.specificInquiry(postId: postId))
    }
    
    func comment(query: CommentRequest, postId: String) -> Single<Result<Comment, AFError>> {
        return mainMakeRequest(router: MainRouter.comment(query: query, postId: postId))
    }
    
    func likes(query: LikesRequest, postId: String) -> Single<Result<LikesResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.likes(query: query, postId: postId))
    }
    
    func profile(userId: String) -> Single<Result<ProfileResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.otherProfile(userId: userId))
    }
    
    func profile(query: ProfileEditRequest) -> Single<Result<ProfileResponse, AFError>> {
        let router = MainRouter.meProfileEdit(query: query)
        let url = router.baseURL.appendingPathComponent(router.path).absoluteString.removingPercentEncoding!
        let header = HTTPHeaders(router.header)
        let method = router.method

        return Single<Result<ProfileResponse, AFError>>.create { single in
            AF.upload(multipartFormData: router.multipart, to: url, method: method, headers: header)
                .responseDecodable(of: ProfileResponse.self) { response in
                    switch response.result {
                    case .success(let profileResponse):
                        single(.success(.success(profileResponse)))
                    case .failure(let error):
                        single(.success(.failure(error)))
                    }
                }
            return Disposables.create()
        }
    }
    
    func follow(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.follow(userId: userId))
    }
    
    func followCancel(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.followCancel(userId: userId))
    }
}
