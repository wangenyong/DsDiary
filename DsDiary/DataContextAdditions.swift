//
//  DataContextAdditions.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/16.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import AlecrimCoreData

extension DataContext {
    var diary: Table<Diary> {
        return Table<Diary>(dataContext: self)
    }
}

