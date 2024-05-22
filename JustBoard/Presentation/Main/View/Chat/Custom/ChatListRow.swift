//
//  ChatListRow.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI
import Kingfisher

struct ChatListRow: View {
    let chat : ChatResponse
    let isNew : Bool
    
    var body: some View {
        HStack {
            
            let myId = UserDefaultManager.shared.userId
            // oppenet profile
            let opponentProfile = chat.participants[0].userID == myId ? chat.participants[1].profileImageToUrl : chat.participants[0].profileImageToUrl
            let opponentNickname = chat.participants[0].userID == myId ? chat.participants[1].nick : chat.participants[0].nick
            
            KFImage.url(opponentProfile)
                .requestModifier(AuthManager.kingfisherAuth())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60) //resize
                .clipShape(.circle)
            VStack(alignment:.leading, spacing: 5) {
                Text(opponentNickname)
                    .bold()
                    .font(.title3)
                
                if let lastChat = chat.lastChat {
                    Text(lastChat.content)
                        .lineLimit(0)
                }
            }
            Spacer()
            // 오늘 인 경우 HH:mm, 오닐 아닐 경우 일자만
            VStack (alignment : .center, spacing: 10) {
                Text(chat.updatedAt.toDate()!
                    .toString(dateFormat: "HH:mm"))
                    .font(.subheadline)
                    .bold()
                if isNew {
                    DesignSystem.sfSymbolSwiftUI.new
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(DesignSystem.swiftUIColorSet.blue)
                }
            }
        }
        
    }
}
