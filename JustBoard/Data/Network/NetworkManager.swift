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
    
    private func makeRequest<T: Decodable>(router: URLRequestConvertible) -> Single<Result<T, AFError>> {
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
        return makeRequest(router: UserRouter.join(query: query))
    }
    
    func createLogin(query: LoginRequest) -> Single<Result<LoginResponse, AFError>> {
        return makeRequest(router: UserRouter.login(query: query))
    }
    
    func validationEmail(query: EmailValidationRequest) -> Single<Result<String, AFError>> {
        return makeRequest(router: UserRouter.emailValidation(query: query))
    }
    
    //MARK: - Main
    func post(query: FilesRequest, category: String) -> Single<Result<FilesResponse, AFError>> {
        let router = MainRouter.files(query: query, category: category)
        let url = router.baseURL.appendingPathComponent(router.path).absoluteString.removingPercentEncoding!
        let header = HTTPHeaders(router.header)
        
        return Single<Result<FilesResponse, AFError>>.create { single in
            AF.upload(multipartFormData: router.multipart, to: url, headers: header, interceptor: AuthManager())
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
        return makeRequest(router: MainRouter.write(query: query))
    }
    
    func post(query: InquiryRequest) -> Single<Result<InquiryResponse, AFError>> {
        return makeRequest(router: MainRouter.inquiry(query: query))
    }
    
    func post(postId: String) -> Single<Result<PostResponse, AFError>> {
        return makeRequest(router: MainRouter.specificInquiry(postId: postId))
    }
    
    func comment(query: CommentRequest, postId: String) -> Single<Result<Comment, AFError>> {
        return makeRequest(router: MainRouter.comment(query: query, postId: postId))
    }
    
    func likes(query: LikesRequest, postId: String) -> Single<Result<LikesResponse, AFError>> {
        return makeRequest(router: MainRouter.likes(query: query, postId: postId))
    }
    
    func profile(userId: String) -> Single<Result<ProfileResponse, AFError>> {
        return makeRequest(router: MainRouter.otherProfile(userId: userId))
    }
    
    func follow(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return makeRequest(router: MainRouter.follow(userId: userId))
    }
    
    func followCancel(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return makeRequest(router: MainRouter.followCancel(userId: userId))
    }
}
