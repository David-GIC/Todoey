//
//  ItemModel.swift
//  Todoey
//
//  Created by Sopheap Sopheadavid on 7/19/19.
//  Copyright © 2019 Sopheap Sopheadavid. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // relationshaip
    // one category to many items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
