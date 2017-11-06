//
//  Protocol.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result
{
    case  ok(msg : String)
    
    case  empty
    
    case  failed(msg : String)
}

extension Result
{
    var isVaild : Bool
    {
        switch self {
            
        case .ok:
    
            return true
        default:
            return false
        }
    
    }

}

extension Result
{
    var textColor: UIColor {
        switch self {
        case .ok:
            return UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
        case .empty:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
}

extension Result {
    
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
}


extension Reactive where Base : UILabel
{
    var validateResult : UIBindingObserver<Base, Result>
    {
       return UIBindingObserver(UIElement: base, binding: { (label, result) in
        
            label.textColor = result.textColor
            label.text = result.description
        
       })
    }

}

extension Reactive where Base : UITextField
{
    var inputEnable : UIBindingObserver<Base,Result>
    {
        return UIBindingObserver(UIElement: base, binding: { (textField, result) in
            
            
             textField.isEnabled  = result.isVaild
            
        })
    }

}

extension Reactive where Base : UIButton
{
    var valite : UIBindingObserver<Base , Result>
    {
       return UIBindingObserver(UIElement: base, binding: { (button, result) in
        
           button.isEnabled = result.isVaild
           button.alpha = result.isVaild ? 1.0 : 0.5
           button.backgroundColor = result.isVaild ? UIColor.orange : UIColor.groupTableViewBackground
        
        })
    }

}
