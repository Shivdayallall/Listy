//
//  Items.swift
//  myTask
//
//  Created by shiv on 10/21/20.
//

import RealmSwift
import UIKit

class Items: Object {
    @objc dynamic var name = ""
    @objc dynamic var finish = false
    // result data type frpom realm
    let item = List<Items>()
}
