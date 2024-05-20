//
//  ChatViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/19/24.
//

import Foundation
import Combine
import RealmSwift

// SockerIOManager > ReceivedChatData > subscribe > view
final class ChatViewModel : CombineViewModelType {
    var cancellables = Set<AnyCancellable>()
    
    private let chat : ChatResponse
    private var socketManager : SocketIOManager
    private let receivedChatData : PassthroughSubject<LastChat, Never>
    @ObservedResults(Chat.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var chatTable
    
    init(chat : ChatResponse) {
        self.chat = chat
        self.socketManager = SocketIOManager(roomID: chat.roomID)
        self.receivedChatData = socketManager.receivedChatData
        transform()
    }
    
    enum Action {
        case viewOnAppear
        case socketConnection
        case socketDisconnection
        case socketDataReceive
        case sendMessage(message : String)
    }
    
    func action(_ action : Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        case .socketConnection:
            socketManager.establishConnection()
            socketManager.receiveData()
        case .socketDisconnection:
            socketManager.leaveConnection()
        case .socketDataReceive:
            input.socketDataReceive.send(())
        case .sendMessage(message: let message):
            input.sendMessage.send(message)
        }
            
    }
    
    var input = Input()
    @Published var output = Output()
}

extension ChatViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
        var socketDataReceive = PassthroughSubject<Void, Never>()
        var sendMessage = PassthroughSubject<String, Never>()
    }
    
    struct Output { }
    
    func transform() {
        
        // 채팅내역 조회 -> Realm Table에서 가장 마지막 날짜 cursor
        input.viewOnAppear
            .map {
                print(self.chatTable.last?.createdAt, "🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲🥲")
                return NetworkManager.shared.chatList(query: ChatMessageRequest(cursor_date: ""), roomId: self.chat.roomID)
            }
            .switchToLatest()
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error ❗️", error)
                }
            } receiveValue: { chatList in
                print(chatList)
            }
            .store(in: &cancellables)

        
        
        input.socketDataReceive
            .combineLatest(receivedChatData) // 소켓이 연결되고 실시간 채팅값을 가져오는 부분
            .map { return $1 }
            .sink { [weak self] chat in
                guard let self = self else { return }
                
                $chatTable.append(Chat(roomID: chat.roomID, chatID: chat.chatID, userID: chat.sender.userID, nick: chat.sender.nick, profile: chat.sender.profileImage, content: chat.content, createAt: chat.createdAt.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")!))
                
            }
            .store(in: &cancellables)
        
        // Database 저장
        input.sendMessage
            .map {
                return NetworkManager.shared.sendMessage(query: ChatSendRequest(content: $0, files: []), roomId: self.chat.roomID)
            }
            .switchToLatest()
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error ❗️", error)
                }
            } receiveValue: {[weak self] _ in
                guard let self = self else { return }
            }
            .store(in: &cancellables)

    }
}
