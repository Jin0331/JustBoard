//
//  ChatRepository.swift
//  JustBoard
//
//  Created by JinwooLee on 5/20/24.
//

import Foundation
import RealmSwift
import UserNotifications

final class RealmRepository {
    
    private let realm = try! Realm()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func realmLocation() { print("현재 Realm 위치 🌼 - ",realm.configuration.fileURL!) }
    
    //MARK: - CREATE
    // CREATE
    func createPill<T:Object>(_ item : T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error, "- pillCreate Error")
        }
    }
    
    func upsertPillAlarm(pk: ObjectId, alarmName : String, pillList : List<Pill>, type : String, typeTitle : String,
                         alarmStartDate : Date, alarmDate : List<PillAlarmDate>) {
        
        do {
            try realm.write {
                realm.create(PillAlarm.self, value: ["_id":pk, "alarmName": alarmName, "pillList": pillList,
                                                     "type": type, "typeTitle" : typeTitle,
                                                     "alarmStartDate": alarmStartDate,
                                                     "alarmDate":alarmDate,
                                                     "upDate":Date()
                                                    ], update: .modified) }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - READ
    func fetchPillSpecific(itemSeq : Int) -> Pill? {
        let table : Pill? = realm.objects(Pill.self).where {
            $0.itemSeq == itemSeq && $0.isDeleted == false}.first
        
        return table
    }
    
    func fetchPillExist(itemSeq : Int) -> Bool {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)
        
        if table != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchPillExist(alarmName : String) -> Bool {
        
        guard let table = fetchPillAlarm(alarmName: alarmName) else { return false }
        
        return table.isEmpty ? false : true
    }
    
    
    //MARK: - Pill Search
    func fetchPillItem() -> [Pill]? {
        let table = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(table)
    }
    
    //MARK: - PillAralm Group Fetch
    func fetchPillAlarm() -> [PillAlarm]? {
        let table = realm.objects(PillAlarm.self).where {
            $0.isDeleted == false
        }
        return Array(table)
    }
    
    func fetchPillAlarm(alarmName : String) -> [PillAlarm]? {
        let table = realm.objects(PillAlarm.self).where {
            $0.alarmName == alarmName && $0.isDeleted == false
        }
        return Array(table)
    }
    
    // PK로 검색하는 경우
    func fetchPillAlarmSpecific(_id : ObjectId) -> PillAlarm?{
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: _id) else { return nil }
        
        return table
    }
    
    //MARK: - PillAralm Group의 Date Fetch
    func fetchPillAlarmDateItem(alarmName : String) -> [PillAlarmDate]? {
        let table = realm.objects(PillAlarmDate.self).where {
            $0.alarmName == alarmName && $0.isDeleted == false
        }.sorted(byKeyPath: "alarmDate", ascending: true)
        return Array(table)
    }
    
    func fetchPillAlarmDateItem(alaramDate : Date) -> [PillAlarmDate]? {
        let targetDate = Calendar.current.startOfDay(for: alaramDate)
        let table = realm.objects(PillAlarmDate.self).filter("alarmDate >= %@ AND alarmDate < %@", targetDate, Calendar.current.date(byAdding: .day, value: 1, to: targetDate)!)
            .where {
                $0.alarmGroup.isDeleted == false &&
                $0.isDeleted == false
            }.sorted(byKeyPath: "alarmDate", ascending: true)
        
        return Array(table)
    }
    
    // Alarm group에서 동일한 시간이 있는지 없는지 판단
    func fetchPillAlarmDateItemIsEqual(alarmName : String, alaramDate : Date) -> Bool {
        let table = realm.objects(PillAlarmDate.self).filter("alarmDate == %@", alaramDate)
            .where {
                $0.alarmName == alarmName &&
                $0.alarmGroup.isDeleted == false &&
                $0.isDeleted == false
            }
        
        return table.isEmpty
    }
    
    // Notification Update에서 사용되는 함수
    func fetchPillAlarmDateAndUpdateNotification(alaramDate : Date) -> [PillAlarmDate]? {
        let targetDate = Calendar.current.startOfDay(for: alaramDate)
        let notificationTable = realm.objects(PillAlarmDate.self).filter("alarmDate >= %@ AND alarmDate < %@", targetDate, Calendar.current.date(byAdding: .day, value: 2, to: targetDate)!)
            .where {
                $0.alarmGroup.isDeleted == false && $0.isDeleted == false && $0.isDone == false
            }.sorted(byKeyPath: "alarmDate", ascending: true)
        
        return Array(notificationTable)
    }
    
    // Notification Update에서 사용되는 함수
    func fetchPillAlarmDateAndUpdateNotification(alarmName : String) -> [PillAlarmDate]? {
        let currentDate = Date() // 현재 시간
        // 현재 시간보다 다음시간의 table을 조회한다
        let notificationTable = realm.objects(PillAlarmDate.self).filter("alarmDate >= %@ AND alarmDate < %@", currentDate, Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!) // 오늘 날짜로 제한 검
            .where {
                $0.alarmName == alarmName && $0.isDeleted == false && $0.isDone == false
            }
            .sorted(byKeyPath: "alarmDate", ascending: false) // LIFO이므로 최근 데이터가 마지막에 들어가도록
        
        return Array(notificationTable)
    }
    
    
    
    //MARK: - UPDATE
    func updatePillIsSelect(itemSeq : Int) {
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        do {
            try realm.write {
                table.isSelected.toggle()
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillIsSelectRelease(itemSeq : Int) {
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        do {
            try realm.write {
                table.isSelected = false
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - 삭제 로직
    func updatePillAlarmRealtionIsDelete(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: _id) else { return }
        
        // 기존 존재하던 PillAlarm Table is delete True
        updatePillAlarmDateAllIsDelete(alarmName: table.alarmName)
        
        do {
            try realm.write {
                //                table.pillList.removeAll() <- 이것은 기록으로 남겨두는 것이 좋을 것 같다.
                table.alarmDate.removeAll()
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    // PillAlarmDate Table에서 alarmName에 따라 isDelete 모두 true
    //MARK: - updatePillAlarmRealtionIsDelete의 하위 항목임!!!
    func updatePillAlarmDateAllIsDelete(alarmName : String) {
        guard let table = fetchPillAlarmDateItem(alarmName: alarmName) else { return }
        
        // 기존 등록된 Noti 제거
//        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: table.map { return $0.idToString })
        userNotificationCenter.removeAllNotification(by: table)
        
        // 트랜잭션 시작
        try! realm.write {
            // 모든 레코드의 isDelete 값을 true로 변경
            for item in table {
                item.isDeleted = true
                item.upDate = Date()
            }
        }
    }
    
    func updatePillIsDelete(itemSeq : Int) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        // 해당 Pill이 포함된 AlarmTable을 모두 가져와야 됨
        let alarmTable = Array(table.alarmGroup).filter { return $0.isDeleted == false && $0.pillList.contains(table)}
        // 만약 빈 배열 일 경우, 아직 group이 설정되지 않은 것
        if !alarmTable.isEmpty {
            // alarm Talbe을 순회하며, Pill이 isDelete가 false count 조회 후 1 이하이면 AlarmTable isDelete true
            alarmTable.forEach {
                if $0.pillList.filter({ $0.isDeleted == false }).count == 1 {
                    updatePillAlarmRealtionIsDelete($0._id) // 해당 그룹에 연관된 Date 모두 삭제
                    updatePillAlarmDelete($0._id)
                    print($0.alarmName, "에 포함된 Pill 없으므로 삭제됩니다. ⭕️⭕️⭕️⭕️⭕️⭕️⭕️⭕️")
                }
            }
        }
        
        do {
            try realm.write {
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillImage(itemSeq : Int, imagePath : String) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        do {
            try realm.write {
                table.urlPath = imagePath
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmDelete(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: _id) else { return }
        
        do {
            try realm.write {
                table.alarmName = table.alarmName + "_deleted_" + table.upDate.toStringTime(dateFormat: "yyyyMMdd")
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmDateDelete(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        
        do {
            try realm.write {
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmDateRevise(_ _id : ObjectId, _ reviseDate : Date) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        let newAlarmDate = Calendar.current.hourMinuteRevise(old: table.alarmDate, new: reviseDate)
        // 기존 노티 삭제
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [table.idToString])
        
        if fetchPillAlarmDateItemIsEqual(alarmName: table.alarmName, alaramDate: newAlarmDate) {
            // 수정된 시간에서 시간 분 추출
            do {
                try realm.write {
                    table.alarmDate = newAlarmDate
                    table.isDone = false
                    table.upDate = Date()
                }
            } catch {
                print(error)
            }
            
            // 노티 재등록
            userNotificationCenter.addNotificationRequest(by: table)
        } else {
            updatePillAlarmDateDelete(_id)
        }
        
    }
    
    func updatePillAlarmisDoneTrue(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        
        // 노티 삭제
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [table.idToString])
        
        do {
            try realm.write {
                table.isDone = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmisDoneTrue(_ _id : String) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        
        // 노티 삭제
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [table.idToString])
        
        do {
            try realm.write {
                table.isDone = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmisDoneFalse(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        
        // 노티 추가
        userNotificationCenter.addNotificationRequest(by: table)
        
        do {
            try realm.write {
                table.isDone = false
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - REMOVE
    func removePillItem(row : Pill) {
        do {
            try realm.write {
                realm.delete(row)
            }
        } catch {
            print(error, "- removePillItem Error")
        }
    }
    
    func removeAllPillAlarmDateIsDeleted() {
        
        let itemsToDelete = realm.objects(PillAlarmDate.self)
            .where { $0.isDeleted == true }
        
        do {
            try realm.write {
                realm.delete(itemsToDelete)
            }
        } catch {
            print(error)
        }
    }
    
    // Convert a String to ObjectId
    func stringToObjectId(_ string: String) -> ObjectId? {
        do {
            return try ObjectId(string: string)
        } catch {
            print("Error creating ObjectId: \(error)")
            return nil
        }
    }
}
