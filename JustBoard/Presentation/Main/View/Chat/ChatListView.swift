//
//  ChatListView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatListView: View {
    
    @ObservedObject private var viewModel : ChatListViewModel
    var parentCoordinator : ChatListCoordinator?
    init(chatList: MyChatResponse) {
        self.viewModel = ChatListViewModel(chatList: chatList)
    }
    
    var body: some View {
        VStack() {
            Text("메세지")
                .bold()
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            List {
                ForEach(viewModel.output.data) { chat in
                    ChatListRow(chat: chat)
                        .onTapGesture {
                            parentCoordinator?.toChat(chat: chat)
                        }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        
        .task {
            viewModel.action(.viewOnAppear)
        }
    }
}

