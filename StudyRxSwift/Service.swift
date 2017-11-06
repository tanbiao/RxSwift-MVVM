//
//  Service.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterService
{
    static let instance = RegisterService()
    
    private init() {}
    
}

extension RegisterService
{
   
    func validateUsername(username : String) ->Observable<Result>
    {
        if username.characters.count == 0
        {
            return Observable.just(Result.empty)
        }
        
        if username.characters.count < 6
        {
            return Observable.just(Result.failed(msg: "用户名必须是6位以上"))
        }
        
        if usernameValid(username)
        {
            return Observable.just(Result.failed(msg: "用户已经注册"))
        }
        return Observable.just(Result.ok(msg: "可以使用"))
    }
    
    func validatePassword(password : String) -> Result
    {
        if password.characters.count == 0
        {
            return .empty
        }
        
        if password.characters.count < 6 {
            
            return .failed(msg: "密码必须至少6位")
        }
        return .ok(msg: "可以使用")
    }
    
    func validateRepeatPassword(repeatPassword: String,password : String)->Result
    {
        if repeatPassword.characters.count == 0
        {
            return Result.empty
        }
        
        if repeatPassword.characters.count < 6
        {
            return Result.failed(msg: "重复密码至少6位")
        }
        
        if repeatPassword != password
        {
            return Result.failed(msg: "密码不一致")
        }
        
        return Result.ok(msg: "可以使用")
    }
    
    func register(_ username: String, password: String) -> Observable<Result> {
        let userDic = [username: password]
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
            return .just(.ok(msg: "注册成功"))
        }
        return .just(.failed(msg: "注册失败"))
    }
    
    func registerResult(_ username: String, password: String) -> Result {
        let userDic = [username: password]
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        
        if (userDic as NSDictionary).write(toFile: filePath, atomically: true) {
            return .ok(msg: "注册成功")
        }
        return .failed(msg: "注册失败")
    }

    
    func usernameValid(_ username: String) -> Bool {
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        let usernameArray = userDic?.allKeys
        guard usernameArray != nil else {
            return false
        }
        
        if (usernameArray! as NSArray).contains(username ) {
            return true
        } else {
            return false
        }
    }
    
    func loginUsernameValid(_ username: String) -> Observable<Result> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if usernameValid(username) {
            return Observable.just(.ok(msg: "用户名可用"))
        }
        return Observable.just(.failed(msg: "用户名不存在"))
    }
    
    func login(_ username: String, password: String) -> Observable<Result> {
        
        let filePath = NSHomeDirectory() + "/Documents/users.plist"
        let userDic = NSDictionary(contentsOfFile: filePath)
        if let userPass = userDic?.object(forKey: username) as? String {
            if  userPass == password {
                return .just(.ok(msg: "登录成功"))
            }
        }
        return .just(.failed(msg: "密码错误"))
    }

}

class  DataService
{
    static let instance = DataService()
    
    private init() {}
    
}

extension DataService
{
    func requestData(parm : String)->Observable<Array<String>>
    {
        let dataSource = ["张三","李四","王麻子","张飞","关于","刘备"]
        
        return Observable.just(dataSource, scheduler: MainScheduler.instance)
    }



}
