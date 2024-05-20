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
    
    func upsertPillAlarm(pk: ObjectId, roomID : String, sender : String, content : String, createdAt : Date) {
        
        do {
            try realm.write {
                realm.create(Chat.self, value: ["_id":pk,
                                                "roomID":roomID,
                                                "sender":sender,
                                                "content":content,
                                                "createdAt":createdAt], update: .modified) }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - READ
//    func fetchPillSpecific(itemSeq : Int) -> Pill? {
//        let table : Pill? = realm.objects(Pill.self).where {
//            $0.itemSeq == itemSeq && $0.isDeleted == false}.first
//        
//        return table
//    }
//    
//    func fetchPillExist(itemSeq : Int) -> Bool {
//        
//        let table = fetchPillSpecific(itemSeq: itemSeq)
//        
//        if table != nil {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func fetchPillExist(alarmName : String) -> Bool {
//        
//        guard let table = fetchPillAlarm(alarmName: alarmName) else { return false }
//        
//        return table.isEmpty ? false : true
//    }
}
