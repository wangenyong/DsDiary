//
//  Diary.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/17.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import RealmSwift

class Diary: Object {
    dynamic var uuid = ""
    dynamic var content = ""
    dynamic var weather = ""
    dynamic var date = NSDate()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
