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
        _chatTable.filter = NSPredicate(format: "roomID == %@", chat.roomID)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack { // ScrollView, GeometryReader
                // SwiftUit List Scroll Bottom
                
                if chatTable.isEmpty {
                    textView(text: "서로 주고받은 대화가 없습니다 🥲")
                    Spacer()
                } else {
                    List(chatTable) { chat in
                        
                        let isMe = UserDefaultManager.shared.userId! == chat.userID ? true : false
                        ChatRow(chat: chat, isMe: isMe)
                            .listRowSeparator(.hidden)
                            .id(chat._id)
                        
                        if chat._id == chatTable.last?._id { emptyView() }
                    }
                    .listStyle(.plain)
                    .onChange(of: viewModel.output.scrollToBottom) { newValue in
                        if newValue == true  {
                            DispatchQueue.main.async {
                                withAnimation {
                                    proxy.scrollTo("BOTTOM_ID", anchor: .bottom)
                                }
                            }
                            viewModel.action(.scrollToBottomDispose)
                        }
                    }
                }
                
                HStack {
                    TextField("메세지를 입력해주세요", text: $newMessage)
                        .padding()
                        .lineLimit(2)
                    Button(action: {
                        viewModel.action(.sendMessage(message: newMessage))
                        newMessage = ""
                    }, label: {
                        DesignSystem.sfSymbolSwiftUI.send
                            .foregroundStyle(DesignSystem.swiftUIColorSet.lightBlack)
                    })
                    .padding()
                }
            }
            .onTapGesture {
                viewModel.action(.scrollToBottom)
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
    
    fileprivate func textView(text : String) -> some View {
        return Text(text)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
