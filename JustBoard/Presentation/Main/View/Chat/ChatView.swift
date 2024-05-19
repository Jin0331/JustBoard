//
//  ChatView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject private var viewModel : ChatViewModel
    @State private var newMessage = ""
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
            
            HStack {
                TextField("메세지를 입력해주세요", text: $newMessage)
                    .padding()
                Button(action: {
                    viewModel.action(.sendMessage(message: newMessage))
                }, label: {
                    Image(systemName: "paperplane")
                })
                .padding()
            }
            
        }
        .task {
            socketManager.establishConnection()
            viewModel.action(.viewOnAppear)
        }
    }
}
