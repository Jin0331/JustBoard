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
        
    }
}
