//
//  Items.swift
//  myTask
//
//  Created by shiv on 10/21/20.
//

import RealmSwift
import Foundation

class Items: Object {
    @objc dynamic var name = ""
    @objc dynamic var finish = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItem")
    let item = List<Items>()
}
