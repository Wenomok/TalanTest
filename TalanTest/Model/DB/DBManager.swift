//
//  DBManager.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit
import RealmSwift

protocol DBManagerObserver {
    func added(item: TODOItem)
    func removed(item: TODOItem)
    func updated(item: TODOItem)
    func checkUpdated(item: TODOItem, isChecked: Bool)
    
    func failedAdd(item: TODOItem, error: Error)
    func failedRemove(item: TODOItem, error: Error)
    func failedUpdateCheck(item: TODOItem, error: Error)
    func failedUpdate(item: TODOItem, error: Error)
}

class DBManager: NSObject {
    static let shared: DBManager = DBManager.init()
    
    private let dbQueue: DispatchQueue = DispatchQueue.init(label: "db_queue")
    
    private var realm: Realm!
    
    var observer: DBManagerObserver?
    
    func prepareDB(completion: ((Bool) -> ())?) {
        let realmConfig = Realm.Configuration.init(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = realmConfig
        
        do {
            realm = try Realm.init()
            completion?(false)
        } catch(let error) {
            debugPrint(error)
            completion?(true)
        }
    }
    
    func getUsedImageNames() -> [String] {
        var usedImageNames: [String] = []
        realm.objects(TODOItemDBObject.self).forEach { dbItem in
            if let imageName = dbItem.imageName, !usedImageNames.contains(imageName) {
                usedImageNames.append(imageName)
            }
        }
        
        return usedImageNames
    }
    
    func getTODOList() -> [TODOItem] {
        var items: [TODOItem] = []
        
        let dbItems = realm.objects(TODOItemDBObject.self)
        
        dbItems.forEach { dbItem in
            items.append(TODOItem.createItem(dbItem: dbItem))
        }
        
        return items
    }
    
    func add(item: TODOItem) {
        do {
            try realm.write({
                realm.add(item.dbItem())
                
                observer?.added(item: item)
            })
        } catch(let error) {
            observer?.failedAdd(item: item, error: error)
        }
    }
    
    func remove(item: TODOItem) {
        do {
            try realm.write({
                let dbItem = realm.objects(TODOItemDBObject.self).filter("createDate == %@", item.createDate)
                
                realm.delete(dbItem)
                observer?.removed(item: item)
            })
        } catch(let error) {
            observer?.failedRemove(item: item, error: error)
        }
    }
    
    func updateCheck(forItem item: TODOItem, isChecked: Bool) {
        do {
            if let dbItem = realm.objects(TODOItemDBObject.self).filter("createDate == %@", item.createDate).first {
                try realm.write({
                    dbItem.updateProperties(byItem: item)
                    observer?.checkUpdated(item: item, isChecked: isChecked)
                })
            } else {
                observer?.failedUpdateCheck(item: item, error: NSError.init(domain: "domain", code: 101, userInfo: [NSLocalizedDescriptionKey: "Not found"]))
            }
        } catch(let error) {
            observer?.failedUpdateCheck(item: item, error: error)
        }
    }
    
    func update(item: TODOItem) {
        do {
            if let dbItem = realm.objects(TODOItemDBObject.self).filter("createDate == %@", item.createDate).first {
                try realm.write({
                    dbItem.updateProperties(byItem: item)
                    observer?.updated(item: item)
                })
            } else {
                observer?.failedUpdate(item: item, error: NSError.notFound)
            }
        } catch(let error) {
            observer?.failedUpdate(item: item, error: error)
        }
    }
    
    // MARK: Private
    
//    private func getProperty(type: Class)
}
