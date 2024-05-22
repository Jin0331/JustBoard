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
    private let realmRepository = RealmRepository()
    @ObservedResults(RealmChatResponse.self) var chatListTable
    
    init(chatList : MyChatResponse) {
        self.chatList = chatList
        transform()
    }
    
    enum Action {
        case viewOnAppear
        case isNew(roomID:String)
    }
    
    func action(_ action : Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .isNew(roomID : let roomID):
            input.isNew.send(roomID)
            
        }
    }
    
    var input = Input()
    @Published var output = Output()
}

extension ChatListViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
        var isNew = PassthroughSubject<String, Never>()
    }
    
    struct Output { }
    
    func transform() {
        /*
         1. 서버, 로컬 둘다 X
         2. 서버 O, 로컬 X -> 확인 안 한 것으로 간주하고
          -> 1) 내가 마지막으로 보낸 경우 isNew = false
             2) 상대방이 마지막으로 보낸 경우 isNew = true
         3. 서버 O, 로컬 O ->
         -> 1) 내가 마지막으로 보낸 경우 isNew = false
            2) 상대방이 마지막으로 보낸 경우 isNew = true
         */
        
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
            } receiveValue: { [weak self] (chatResponse: MyChatResponse) in
                guard let self = self else { return }
                
                chatResponse.data.forEach { [weak self] chat in
                    guard let self = self else { return }
                    let myId = UserDefaultManager.shared.userId!
                    // 3 서버 O, 로컬 O
                    if let serverLastChat = chat.lastChat, let localLastChat = realmRepository.fetchChatList(roomID: chat.roomID)?.lastChat {
                        if serverLastChat.createdAt.toDate()! > localLastChat.createdAt && serverLastChat.sender.userID != myId {
                            realmRepository.upsertChatListWithIsNewTrue(chatResponse: chat)
                        } else {
                            realmRepository.upsertChatList(chatResponse: chat)
                        }
                    // 2 서버 o 로컬 x
                    } else if let serverLastChat = chat.lastChat {
                        if serverLastChat.sender.userID != myId {
                            realmRepository.upsertChatListWithIsNewTrue(chatResponse: chat)
                        } else {
                            realmRepository.upsertChatList(chatResponse: chat)
                        }
                    } else {
                        realmRepository.upsertChatList(chatResponse: chat)
                    }
                }
                
            }
            .store(in: &cancellables)
        
        input.isNew
            .sink { [weak self] roomID in
                guard let self = self else { return }
                realmRepository.fetchIsNewToFalse(roomID: roomID)
            }
            .store(in: &cancellables)
    }
}
