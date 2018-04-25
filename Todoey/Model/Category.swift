//
//  Category.swift
//  Todoey
//
//  Created by Satyia Anand on 24/04/2018.
//  Copyright © 2018 Satyia Anand. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Items>()
}
