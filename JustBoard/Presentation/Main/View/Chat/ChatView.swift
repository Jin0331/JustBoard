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
    @ObservedResults(Chat.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: true)) var chatTable
    @State private var newMessage = ""
    var parentCoordinator : ChatCoordinator?
    
    init(chat: ChatResponse) {
        self.viewModel = ChatViewModel(chat: chat)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack { // ScrollView, GeometryReader
                // SwiftUit List Scroll Bottom
                List(chatTable) { chat in
                    
                    let isMe = UserDefaultManager.shared.userId! == chat.userID ? true : false
                    ChatRow(chat: chat, isMe: isMe)
                        .listRowSeparator(.hidden)
                        .id(chat._id)
                    
                    if chat._id == chatTable.last?._id { emptyView() }
                }
                .listStyle(.plain)
                
                HStack {
                    TextField("메세지를 입력해주세요", text: $newMessage)
                        .padding()
                    Button(action: {
                        viewModel.action(.sendMessage(message: newMessage))
                    }, label: {
                        Image(systemName: "paperplane")
                            .foregroundStyle(DesignSystem.swiftUIColorSet.lightBlack)
                    })
                    .padding()
                }
                
            }
            .onChange(of: viewModel.output.scrollToBottom) { newValue in
                if newValue == true  {
                    DispatchQueue.main.async { proxy.scrollTo("BOTTOM_ID", anchor: .bottom) }
                    viewModel.action(.scrollToBottom)
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
}

extension ChatView {
    fileprivate func emptyView() -> some View {
        return VStack {
            Text("")
        }
        .padding(.top, 0)
        .padding(.bottom, 0)
        .frame(height: 0.0)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        .id("BOTTOM_ID")
    }
}
