//
//  TODOItem.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

class TODOItem: NSObject {
    var title: String
    var desc: String?
    var createDate: Date
    var doneDate: Date?
    var imageData: ImageData?
    var isDone: Bool
    
    init(title: String, desc: String?, createDate: Date, doneDate: Date?, imageData: ImageData?, isDone: Bool) {
        self.title = title
        self.desc = desc
        self.createDate = createDate
        self.doneDate = doneDate
        self.imageData = imageData
        self.isDone = isDone
        
        super.init()
    }
    
    static func createItem(dbItem: TODOItemDBObject) -> TODOItem {
        return TODOItem.init(title: dbItem.title, desc: dbItem.desc,
                             createDate: dbItem.createDate, doneDate: dbItem.doneDate,
                             imageData: dbItem.imageName != nil ? ImageData.init(imageName: dbItem.imageName!) : nil,
                             isDone: dbItem.isDone)
    }
    
    func dbItem() -> TODOItemDBObject {
        return TODOItemDBObject.init(title: title, desc: desc, createDate: createDate,
                                     doneDate: doneDate, imageName: imageData?.imageName, isDone: isDone)
    }
    
    func update(title: String, desc: String?) {
        self.title = title
        self.desc = desc
    }
    
    func update(isDone: Bool, doneDate: Date?) {
        self.isDone = isDone
        self.doneDate = doneDate
    }
    
    func update(imageData: ImageData?) {
        self.imageData = imageData
    }
    
    func getImageURL() -> URL? {
        if let imageName = self.imageData?.imageName {
            return FileManager.default.cachedImagesURL()?.appendingPathComponent("\(imageName).png")
        } else {
            return nil
        }
    }
}
