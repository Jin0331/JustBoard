//
//  ChatListView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        VStack() {
            Text("메세지")
                .bold()
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                ForEach(0..<50) { _ in
                    ChatListRow()
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ChatListView()
}
