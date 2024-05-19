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
    var cancellable = Set<AnyCancellable>()
    
    let chat : ChatResponse
    
    init(chat : ChatResponse) {
        self.chat = chat
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

extension ChatViewModel {
    struct Input {
        var viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var message : [ChatResponse] = []
    }
    
    func transform() {
        
        input.viewOnAppear
            .combineLatest(SocketIOManager.shared.receivedChatData)
            .map { return $1}
            .sink { chat in
                output.message.append(chat)
            }
        
    }
}


/*
 var cancellable = Set<AnyCancellable>()
 
 @Published var message : [RealChat] = []
 
 init() {
     SocketIOManager.shared.receivedChatData
         .sink { chat in
             self.message.append(chat)
         }
         .store(in: &cancellable)
 }
 */
