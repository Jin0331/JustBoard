//
//  ChatRow.swift
//  JustBoard
//
//  Created by JinwooLee on 5/20/24.
//

import SwiftUI
import Kingfisher

struct ChatRow: View {
    
    var chat : Chat
    var isMe : Bool
    var body: some View {
        
        HStack(alignment: .top, spacing: 10) {
            
            if isMe {
                Spacer()
            } else {
                let url = "https://picsum.photos/id/237/200/300"
                KFImage.url(URL(string: url)!)
                    .resizable()
                    .frame(width: 40, height: 40) //resize
                    .clipShape(.circle)
            }
            
            
            HStack(alignment:.bottom) {
                if isMe {
                    timeText()
                }
                Text(chat.content)
                    .padding()
                    .foregroundStyle(isMe ? DesignSystem.swiftUIColorSet.white : DesignSystem.swiftUIColorSet.black)
                    .background(isMe ? Color.blue : DesignSystem.swiftUIColorSet.lightGray)
                    .font(.subheadline)
                .cornerRadius(10)
                
                if !isMe {
                    timeText()
                }
            }
            

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

extension ChatRow {
    fileprivate func timeText() -> some View {
        return Text(chat.createdAt.toString(dateFormat: "HH:mm"))
            .font(.caption)
    }
}
