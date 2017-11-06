//
//  RegisterViewModel.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel
{
    //界面上的输入
    let username = Variable("")
    let password = Variable("")
    let repeatPassword = Variable("")
    let registerTaps = PublishSubject<Void>()
    
    //根据界面上输入处理后的结果
    let usernameUsable : Observable<Result>
    let passwordUsable : Observable<Result>
    let repeatPasswordUsable : Observable<Result>
    let registButtonEnable : Observable<Bool>
    let registResult : Observable<Result>
    
    
    init()
    {
        let service = RegisterService.instance
        
        usernameUsable = username.asObservable().flatMapLatest({ (username) -> Observable<Result> in
            return service.validateUsername(username: username).asObservable().observeOn(MainScheduler.instance).catchErrorJustReturn(Result.failed(msg: "错误信息"))
        }).shareReplay(1)
        
        passwordUsable = password.asObservable().map({ (password) -> Result in
            
            return service.validatePassword(password: password)
            
        }).shareReplay(1)
        
        //处理重复密码
        repeatPasswordUsable = Observable<Result>.combineLatest(password.asObservable(), repeatPassword.asObservable(), resultSelector: { (password, repeatPassword) -> Result in
            
            return service.validateRepeatPassword(repeatPassword: repeatPassword, password: password)
        })
        
        //处理注册按钮是否可以点
        registButtonEnable  = Observable.combineLatest(usernameUsable, passwordUsable, repeatPasswordUsable, resultSelector: { (userName, passWord,repeatpassword ) -> Bool in

            return userName.isVaild && passWord.isVaild && repeatpassword.isVaild
        })
        
        let usernameAndPassword = Observable.combineLatest(username.asObservable(), password.asObservable()) {
            ($0, $1)
        }
          
        registResult = registerTaps.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
                
                return service.register(username, password: password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.failed(msg: "注册出错"))
            }
            .shareReplay(1)
  
    }

    
    
    
}
