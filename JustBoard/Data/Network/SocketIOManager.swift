//
//  SocketIOManager.swift
//  SeSAC4SwiftUIChatLectureApp
//
//  Created by JinwooLee on 5/17/24.
//

import Foundation
import SocketIO
import Combine

struct RealChat : Decodable, Hashable {
    let content : String
    let createdAt: String
}

final class SocketIOManager {
    static let shared = SocketIOManager()
    
    var manager : SocketManager!
    var socket : SocketIOClient!
    
    let baseURL = URL(string: "http://lslp.sesac.kr:8244/v1")!
    let roomID = "/chats-664601e52b0224d656149cb1"
    
    var receivedChatData = PassthroughSubject<RealChat, Never>()
    
    private init () {
        
        print(#function, "init")
        
        manager = SocketManager(socketURL: baseURL, config: [.log(true), .compress])
        socket = manager.socket(forNamespace: roomID)
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
        }
        
        // [Any] > Data > Struct
        socket.on("chat") { dataArray, ack in
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let decodedData = try JSONDecoder().decode(RealChat.self, from: result)
                    
                    self.receivedChatData.send(decodedData)
                    
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
