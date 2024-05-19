//
//  ChatListView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatListView: View {
    
    @ObservedObject private var viewModel : ChatListViewModel
    
    init(chatList: MyChatResponse) {
        self.viewModel = ChatListViewModel(chatList: chatList)
    }
    
    var body: some View {
        
        NavigationStack {
            VStack() {
                Text("메세지")
                    .bold()
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                List {
                    ForEach(viewModel.output.data) { chat in
                        NavigationLink(value :chat) {
                            ChatListRow(chat: chat)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                // value 값에 따라 모든 네비게이션의 다음 뷰 지정
                .navigationDestination(for: ChatResponse.self, destination: { chat in
                    ChatView(roomId: chat.roomID)
                })
            }
        }

        .task {
            viewModel.action(.viewOnAppear)
        }
    }
}

