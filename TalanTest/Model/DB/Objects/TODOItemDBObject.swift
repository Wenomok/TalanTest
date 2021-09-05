//
//  TODOItemDBObject.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit
import RealmSwift

class TODOItemDBObject: Object {
    @objc dynamic var title: String
    @objc dynamic var desc: String?
    @objc dynamic var createDate: Date
    @objc dynamic var doneDate: Date?
    @objc dynamic var imageName: String?
    @objc dynamic var isDone: Bool
    
    init(title: String, desc: String?, createDate: Date, doneDate: Date?, imageName: String?, isDone: Bool) {
        self.title = title
        self.desc = desc
        self.createDate = createDate
        self.imageName = imageName
        self.isDone = isDone
    }
    
    override init() {
        self.title = ""
        self.desc = ""
        self.createDate = Date.init()
        self.doneDate = nil
        self.imageName = nil
        self.isDone = false
    }
    
    func updateProperties(byItem item: TODOItem) {
        if !title.elementsEqual(item.title) {
            title = item.title
        }
        if desc != desc {
            desc = item.desc
        }
        if imageName != item.imageData?.imageName {
            imageName = item.imageData?.imageName
        }
        if isDone != item.isDone {
            isDone = item.isDone
        }
        if doneDate != item.doneDate {
            doneDate = item.doneDate
        }
    }
}
