//
//  Category.swift
//  Todoey
//
//  Created by Nilesh Kumar on 15/06/18.
//  Copyright © 2018 NKM. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name : String = ""
   let items = List<Item>()
}
