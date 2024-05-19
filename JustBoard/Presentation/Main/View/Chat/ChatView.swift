//
//  ChatView.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import SwiftUI

struct ChatView: View {
    
    var roomId : String
    
    var body: some View {
        Text(roomId)
    }
}

#Preview {
    ChatView(roomId: "asdsazxcasd")
}
