//
//  LoginViewModel.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class LoginViewModel
{
    let usernameUsable : Driver<Result>
    let loginButtonEnabled : Driver<Bool>
    let loginResult: Driver<Result>
    
    init(input:(username:Driver<String>,password:Driver<String>,loginTaps:Driver<Void>))
    {
        let service = RegisterService.instance
        
        usernameUsable = input.username.flatMapLatest({ (userName) -> Driver<Result> in
            
            return service.loginUsernameValid(userName).asDriver(onErrorJustReturn: Result.failed(msg: "连接服务失败"))
        })
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) { (userName, password) -> (String,String) in
            
            let input = (userName,password)
            
            return input
        }
        
        //这个是
        loginResult = input.loginTaps.withLatestFrom(usernameAndPassword).flatMapLatest({ (result) -> Driver<Result> in
            
            return service.login(result.0, password: result.1).asDriver(onErrorJustReturn: Result.failed(msg: "连接服务失败"))
        })
        
        loginButtonEnabled = usernameAndPassword.map({ (combine) -> Bool in
            
            return combine.0.characters.count > 0 && combine.1.characters.count > 0
        })

        
    }
        
    
}
