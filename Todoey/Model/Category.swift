//
//  CategoryModel.swift
//  Todoey
//
//  Created by Sopheap Sopheadavid on 7/19/19.
//  Copyright © 2019 Sopheap Sopheadavid. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    // relationshaip
    // one category to many items
    let items = List<Item>()
}
