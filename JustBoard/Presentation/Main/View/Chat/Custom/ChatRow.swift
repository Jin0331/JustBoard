//
//  ChatRow.swift
//  JustBoard
//
//  Created by JinwooLee on 5/20/24.
//

import SwiftUI

struct ChatRow: View {
    
    var chat : LastChat
    var isMe : Bool
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 10) {
            
            if isMe {
                Spacer()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Text(chat.content)
                .padding()
                .foregroundStyle(isMe ? Color.white : Color.black)
                .background(isMe ? Color.blue : Color.gray)
                .font(.subheadline)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}
