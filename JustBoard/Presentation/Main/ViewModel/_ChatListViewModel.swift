//
//  ChatListViewModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import Foundation
import Combine

// chatList의 상태를 관리할 수 있도록 변경하는 부분
final class ChatListViewModel : CombineViewModelType {
    var cancellables = Set<AnyCancellable>()
    
    let chatList : MyChatResponse
        
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
    
    struct Output {
        var data : [ChatResponse] = []
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                guard let self = self else { return}
                
                print(chatList.data)
                
                output.data = chatList.data
            }
            .store(in: &cancellables)
    }
}
