//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Nilesh Kumar on 10/06/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?

}
