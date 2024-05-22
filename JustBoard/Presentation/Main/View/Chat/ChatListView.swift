//
//  ChatListView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI
import RealmSwift

struct ChatListView: View {
    
    @ObservedObject private var viewModel : ChatListViewModel
    @ObservedResults(RealmChatResponse.self, sortDescriptor: SortDescriptor(keyPath: "updatedAt", ascending: false)) var chatListTable
    
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
            List(chatListTable) { chat in
                let chatResponse = ChatResponse(from: chat)
                ChatListRow(chat: chatResponse)
                    .onTapGesture {
                        parentCoordinator?.toChat(chat: chatResponse)
                    }                
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
        
        .onAppear {
            
            print("hihi")
            
            viewModel.action(.viewOnAppear)
        }
    }
}

