//
//  Reminder.swift
//  RealmDo
//
//  Created by Tanin on 13/12/2017.
//  Copyright © 2017 landtanin. All rights reserved.
//

import RealmSwift
class Reminder: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var done = false
    
}
