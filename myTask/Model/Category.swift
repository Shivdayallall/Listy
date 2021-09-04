//
//  Category.swift
//  myTask
//
//  Created by shiv on 8/25/21.
//

import RealmSwift
import Foundation

class Category: Object {
    @objc dynamic var categoryName: String = ""
    let todoItem = List<Items>()
    
}
