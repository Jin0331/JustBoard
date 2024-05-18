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
    
    var body: some View {
        
        HStack {
            KFImage.url(URL(string: url)!)
                .resizable()
                .frame(width: 60, height: 60) //resize
                .clipShape(.circle)
            VStack(alignment:.leading) {
                Text("양기웅")
                    .bold()
                Text("ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ")
                    .lineLimit(0)
            }
            Spacer()
            Text("24.01.01")
                .font(.caption)
                .bold()
            Spacer()
        }
        
    }
}

#Preview {
    ChatListRow()
}
