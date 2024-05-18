//
//  ChatListRow.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI
import Kingfisher

struct ChatListRow: View {
    
    let url = "https://picsum.photos/id/237/200/300"
    let chat : ChatResponse
    
    
    var body: some View {
        
        HStack {
            KFImage.url(URL(string: url)!)
                .resizable()
                .frame(width: 60, height: 60) //resize
                .clipShape(.circle)
            VStack(alignment:.leading, spacing: 5) {
                Text(chat.participants[1].nick)
                    .bold()
                    .font(.title3)
                
                if let lastChat = chat.lastChat {
                    Text(lastChat.content)
                        .lineLimit(0)
                }
            }
            Spacer()
            Text("24.01.01")
                .font(.subheadline)
                .bold()
        }
        
    }
}

//#Preview {
//    ChatListRow()
//}
