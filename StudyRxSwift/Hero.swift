//
//  Hero.swift
//  LoginWithRx
//
//  Created by 田腾飞 on 2016/12/3.
//  Copyright © 2016年 tiantengfei. All rights reserved.
//

import UIKit

class Hero: NSObject {
    var name: String = ""
    var intro: String = ""
    var icon: String = ""
    
    init(dict:[String : String])
    {
        super.init()
        self.setValuesForKeys(dict)
    }

}

extension Hero
{
    override func setValue(_ value: Any?, forUndefinedKey key: String)
    {
         print("value===\(value), key=========\(key)")
    }

}
