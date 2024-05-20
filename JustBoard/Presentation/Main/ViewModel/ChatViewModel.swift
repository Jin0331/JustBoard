//
//  ChatViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/19/24.
//

import Foundation
import Combine

// SockerIOManager > ReceivedChatData > subscribe > view
final class ChatViewModel : CombineViewModelType {
    var cancellables = Set<AnyCancellable>()
    
    private let chat : ChatResponse
    private var socketManager : SocketIOManager
    private let receivedChatData : PassthroughSubject<LastChat, Never>
    
    init(chat : ChatResponse) {
        self.chat = chat
        self.socketManager = SocketIOManager(roomID: chat.roomID)
        self.receivedChatData = socketManager.receivedChatData
        transform()
    }
    
    enum Action {
        case socketConnection
        case socketDisconnection
        case socketDataReceive
        case sendMessage(message : String)
    }
    
    func action(_ action : Action) {
        switch action {
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
        var socketDataReceive = PassthroughSubject<Void, Never>()
        var sendMessage = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var message : [LastChat] = []
    }
    
    func transform() {
        
        // 초기 데이터 불러오기
        input.socketDataReceive // 이름 변경 필요, viewOnAppear 시점이 아닌, DB 조회 -> 가장 마지막 cursor(Date) -> 서버 조회 -> 새로운 데이터가 있다면 갱신 없으면 그냥 -> Socker 연결 순으로 되어야 함
            .combineLatest(receivedChatData) // 소켓이 연결되고 실시간 채팅값을 가져오는 부분
            .map { return $1 }
            .sink { [weak self] chat in
                guard let self = self else { return }
                output.message.append(chat)
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
                    print("receive")
                case .failure(let error):
                    print("error ❗️", error)
                }
            } receiveValue: {[weak self] chat in
                guard let self = self else { return }
//                output.message.append(chat) // 어차피 소켓에서 실시간 채팅이 되므로, 해당부분에서 Realm에 데이터를 저장하여야 할 듯
            }
            .store(in: &cancellables)

    }
}
