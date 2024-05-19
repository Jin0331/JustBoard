//
//  ChatView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject private var viewModel : ChatViewModel
    private var socketManager : SocketIOManager
    
    init(chat: ChatResponse) {
        self.socketManager = SocketIOManager(roomID: chat.roomID)
        self.viewModel = ChatViewModel(chat: chat, 
                                       receivedChatData : socketManager.receivedChatData)
    }
    
    var body: some View {
        VStack { // ScrollView, GeometryReader
                 // SwiftUit List Scroll Bottom
            
            List(viewModel.output.message, id: \.self) { chat in
                Text(chat.content)
                    .padding()
                    .background(Color.gray.opacity(0.5))
            }
            
            Button("소켓 해제") {
                socketManager.leaveConnection()
            }
        }
        .task {
            socketManager.establishConnection()
            viewModel.input.viewOnAppear.send(())
        }
    }
}
