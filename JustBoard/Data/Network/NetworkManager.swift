//
//  NetworkManager.swift
//  JustBoard
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import RxSwift
import Combine
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
    
    private func mainMakeRequestCombine<T:Decodable>(router: URLRequestConvertible) -> AnyPublisher<T, AFError> {
        
        let urlRequest = try! router.asURLRequest()
        return AF.request(urlRequest, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .publishDecodable(type: T.self)
            .value()
            .mapError { (afError : AFError) in
                return afError
            }
            .eraseToAnyPublisher()
    }
    
    private func mainMakeRequestCompletion<T:Decodable>(router: URLRequestConvertible, completion : @escaping (Result<T, AFError>) -> Void) {
    
        do {
            let urlRequest = try router.asURLRequest()
            
            AF.request(urlRequest, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error as! AFError))
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
    
    func unlikes(query: LikesRequest, postId: String) -> Single<Result<LikesResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.unlikes(query: query, postId: postId))
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
    
    func profileNotRx(userId:String, handler : @escaping (Result<ProfileResponse, AFError>) -> () ) {
        let router = MainRouter.otherProfile(userId: userId)
        
        do {
            let urlRequest = try router.asURLRequest()
            AF.request(urlRequest, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ProfileResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        handler(.success(data))
                    case .failure(let error):
                        handler(.failure(error))
                    }
                }
        }
        catch {
        }
    }
    
    
    func withdraw() -> Single<Result<JoinResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.withdraw)
    }
    
    func follow(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.follow(userId: userId))
    }
    
    func followCancel(userId: String) -> Single<Result<FollowResponse, AFError>> {
        return mainMakeRequest(router: MainRouter.followCancel(userId: userId))
    }
    
    //MARK: - Chat
    func createChat(query : ChatRequest) -> Single<Result<ChatResponse, AFError>> {
        return mainMakeRequest(router: ChatRouter.create(query: query))
    }
    
    func createChatCompletion(query : ChatRequest, completion : @escaping ((ChatResponse) -> Void)){
        mainMakeRequestCompletion(router: ChatRouter.create(query: query)) { (result: Result<ChatResponse, AFError>) in
            switch result {
            case .success(let chatResponse):
                completion(chatResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func myChatList() -> Single<Result<MyChatResponse, AFError>> {
        return mainMakeRequest(router: ChatRouter.myList)
    }
    
    func myChatList() -> AnyPublisher<MyChatResponse, AFError> {
        return mainMakeRequestCombine(router: ChatRouter.myList)
    }
    
    func chatList(query : ChatMessageRequest, roomId : String) -> AnyPublisher<ChatListResponse, AFError> {
        return mainMakeRequestCombine(router: ChatRouter.messageList(query: query, roomId: roomId))
    }
    
    func sendMessage(query : ChatSendRequest, roomId: String) -> AnyPublisher<LastChat, AFError> {
        return mainMakeRequestCombine(router: ChatRouter.send(query: query, roomId: roomId))
    }
}
