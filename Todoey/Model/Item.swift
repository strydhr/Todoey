//
//  Item.swift
//  Todoey
//
//  Created by Satyia Anand on 24/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //from category item relationship
}
