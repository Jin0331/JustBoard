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
                
                if let _ = chatResponse.lastChat {
                    let myId = UserDefaultManager.shared.userId
                    let opponentNickname = chat.participants[0].userID == myId ? chat.participants[1].nick : chat.participants[0].nick
                    let opponentUserId = chat.participants[0].userID == myId ? chat.participants[1].userID : myId
                    ChatListRow(chat: chatResponse, isNew: chat.isNew)
                        .onTapGesture {
                            viewModel.action(.isNew(roomID: chat.roomID))
                            parentCoordinator?.toChat(chat: chatResponse)
                        }
                        .contextMenu {
                            Button {
                                parentCoordinator?.toProfile(userID: opponentUserId!, me: false, defaultPage: 0)
                            } label: {
                                Label("'" + opponentNickname + "'님의 프로필 조회하기", systemImage: "person")
                            }
                        }
                        
                        .listRowSeparator(.hidden)
                }

            }
            .listStyle(.plain)
            
        }
        
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
    }
}

