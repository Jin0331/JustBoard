//
//  ChatView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI
import RealmSwift

struct ChatView: View {
    
    @ObservedObject private var viewModel : ChatViewModel
    @ObservedResults(Chat.self) var chatTable
    @State private var newMessage = ""
    
    init(chat: ChatResponse) {
        self.viewModel = ChatViewModel(chat: chat)
    }
    
    var body: some View {
        VStack { // ScrollView, GeometryReader
                 // SwiftUit List Scroll Bottom
            List(chatTable) { chat in
                Text(chat.content)
                    .padding()
                    .background(Color.gray.opacity(0.5))
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
        .onAppear {
            viewModel.action(.viewOnAppear)
            viewModel.action(.socketConnection)
            viewModel.action(.socketDataReceive)
        }
        .onDisappear {
            viewModel.action(.socketDisconnection)
        }
    }
}
