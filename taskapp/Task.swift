//
//  Task.swift
//  taskapp
//
//  Created by ouyou on 2019/04/07.
//  Copyright © 2019 ouyou. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // 内容
    @objc dynamic var contents = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    //カテゴリ
    @objc dynamic var category : String = ""
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
