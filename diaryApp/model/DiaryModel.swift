//
//  DiaryModel.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/17.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import Foundation
import RealmSwift

class DiaryModel: Object {
    
    @objc dynamic var japanese1:String = ""
    @objc dynamic var japanese2:String = ""
    @objc dynamic var japanese3:String = ""
    @objc dynamic var japanese4:String = ""
    @objc dynamic var japanese5:String = ""
    @objc dynamic var english1:String = ""
    @objc dynamic var english2:String = ""
    @objc dynamic var english3:String = ""
    @objc dynamic var english4:String = ""
    @objc dynamic var english5:String = ""
    @objc dynamic var checkedJapanese:String = ""
    @objc dynamic var checkedEnglish:String = ""
    @objc dynamic var checkedLineNumber:Int = 0
    @objc dynamic var createdAt:String = ""


}
