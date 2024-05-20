//
//  SocketIOManager.swift
//  SeSAC4SwiftUIChatLectureApp
//
//  Created by JinwooLee on 5/17/24.
//

import Foundation
import SocketIO
import Combine

final class SocketIOManager {
    var manager : SocketManager
    var socket : SocketIOClient
    let baseURL = URL(string: APIKey.baseURLWithVersion())!
    var receivedChatData = PassthroughSubject<LastChat, Never>()
    var roomID : String
    
    init(roomID : String) {
        
        self.roomID = "/chats-" + roomID
        
        manager = SocketManager(socketURL: baseURL, config: [.log(false), .compress])
        socket = manager.socket(forNamespace: self.roomID)
    }
    
    func receiveData() {
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
        }
        
        // [Any] > Data > Struct
        socket.on("chat") { [weak self] dataArray, ack in
            guard let self = self else { return }
            
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let decodedData = try JSONDecoder().decode(LastChat.self, from: result)
                    
                    receivedChatData.send(decodedData)
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    func leaveConnection() {
        socket.disconnect()
    }
}
