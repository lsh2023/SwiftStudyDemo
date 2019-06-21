//
//  CustomModel.swift
//  SwiftStudyDemo
//
//  Created by u1city on 2019/6/18.
//  Copyright © 2019 lsh. All rights reserved.
//

import UIKit

class CustomModel: Codable {
    var text : String?
    var isSelect : Bool?
    
    init(text:String,isSelect:Bool) {
        self.text = text
        self.isSelect = isSelect
    }
    
}

class CustomHeaderModel: Codable {
    var headerArray : [CustomModel]
    var time : String?
    
    init(headerArray:[CustomModel],time:String) {
        self.headerArray = headerArray
        self.time = time
    }
    
}
