//
//  ChatListViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import Foundation
import Combine
import RealmSwift

// chatList의 상태를 관리할 수 있도록 변경하는 부분
final class ChatListViewModel : CombineViewModelType {
    var cancellables = Set<AnyCancellable>()
    
    let chatList : MyChatResponse
    @ObservedResults(RealmChatResponse.self) var chatListTable
    
    init(chatList : MyChatResponse) {
        self.chatList = chatList
        transform()
    }
    
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action : Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        }
    }
    
    var input = Input()
    @Published var output = Output()
}

extension ChatListViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output { }
    
    func transform() {
        input.viewOnAppear
            .map {
                return NetworkManager.shared.myChatList()
            }
            .switchToLatest()
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error ❗️", error)
                }
            } receiveValue: { [weak self] chatResponse in
                guard let self = self else { return }
                
                chatResponse.data.forEach { chat in
                    print(chat)
                }
                
            }
            .store(in: &cancellables)
    }
}
