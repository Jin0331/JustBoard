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
    
    let chat : ChatResponse
    let receivedChatData : PassthroughSubject<LastChat, Never>
    
    init(chat : ChatResponse, receivedChatData: PassthroughSubject<LastChat, Never>) {
        self.chat = chat
        self.receivedChatData = receivedChatData
        transform()
    }
    
    enum Action {
        case viewOnAppear
        case sendMessage(message : String)
    }
    
    func action(_ action : Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
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
        var sendMessage = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var message : [LastChat] = []
    }
    
    func transform() {
        
        input.viewOnAppear
            .combineLatest(receivedChatData)
            .map { return $1}
            .sink { [weak self] chat in
                guard let self = self else { return }
                output.message.append(chat)
            }
            .store(in: &cancellables)
        
        input.sendMessage
            .sink { newMessage in
                print(newMessage, "받은 메세지✅")
            }
            .store(in: &cancellables)
        
    }
}
