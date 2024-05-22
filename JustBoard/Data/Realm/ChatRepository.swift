//
//  ChatRepository.swift
//  JustBoard
//
//  Created by JinwooLee on 5/20/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func realmLocation() { print("현재 Realm 위치 🌼 - ",realm.configuration.fileURL!) }
    
    //MARK: - CREATE
    // CREATE
    func createTable<T:Object>(_ item : T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error, "- Create Error")
        }
    }
    
    func upsertChatList(chatResponse : ChatResponse)  {
        
        do {
            try realm.write {
                realm.create(RealmChatResponse.self, value: ["roomID":chatResponse.roomID,
                                                             "createdAt":chatResponse.createdAt.toDate()!,
                                                             "updatedAt":chatResponse.updatedAt.toDate()!,
                                                             "participants": chatResponse.participants.map(RealmSender.init),
                                                             "lastChat": chatResponse.lastChat.map(RealmLastChat.init) ?? nil
                                                ],
                             update: .modified) }
        } catch {
            print(error)
        }
    }
    
    func upsertChatListWithIsNewTrue(chatResponse : ChatResponse)  {
        
        do {
            try realm.write {
                realm.create(RealmChatResponse.self, value: ["roomID":chatResponse.roomID,
                                                             "createdAt":chatResponse.createdAt.toDate()!,
                                                             "updatedAt":chatResponse.updatedAt.toDate()!,
                                                             "participants": chatResponse.participants.map(RealmSender.init),
                                                             "lastChat": chatResponse.lastChat.map(RealmLastChat.init) ?? nil,
                                                             "isNew":true
                                                ],
                             update: .modified) }
        } catch {
            print(error)
        }
    }
    
    func isExistChat(roomID : String) -> Bool {
        let table = realm.objects(Chat.self).where {
            $0.roomID == roomID
        }
        
        return table.isEmpty ? false : true
    }
    
    func fetchIsNewToFalse(roomID : String) {
        guard let table = realm.object(ofType:RealmChatResponse.self, forPrimaryKey: roomID) else { return }
        
        do {
            try realm.write {
                if table.isNew {
                    table.isNew = false
                }
            }
        } catch {
            print(error)
        }
    }
    
    func fetchIsNewToTrue(roomID : String) {
        guard let table = realm.object(ofType:RealmChatResponse.self, forPrimaryKey: roomID) else { return }
        
        do {
            try realm.write {
                if !table.isNew {
                    table.isNew = true
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    func fetchChatList(roomID : String) -> RealmChatResponse? {
        guard let table = realm.object(ofType:RealmChatResponse.self, forPrimaryKey: roomID) else { return nil }
        
        return table
    }
}
