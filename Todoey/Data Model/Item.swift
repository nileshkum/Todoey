//
//  Item.swift
//  Todoey
//
//  Created by Nilesh Kumar on 15/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
