//
//  RegisterViewController.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class RegisterViewController: UITableViewController {
    
 
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    lazy var disposeBag = DisposeBag()
    
    
    override func viewDidLoad()
    { 
        super.viewDidLoad()
        
        let viewModel = RegisterViewModel()
        
        usernameTextField.rx.text.orEmpty
        .bind(to: viewModel.username)
        .addDisposableTo(disposeBag)
        
        viewModel.usernameUsable
        .bind(to: usernameLabel.rx.validateResult)
        .addDisposableTo(disposeBag)
        
        passwordTextField.rx.text.orEmpty
        .bind(to: viewModel.password)
        .addDisposableTo(disposeBag)
        
        viewModel.passwordUsable
        .bind(to: passwordLabel.rx.validateResult)
        .addDisposableTo(disposeBag)
        
        repeatPasswordTextField.rx.text.orEmpty
        .bind(to: viewModel.repeatPassword)
        .addDisposableTo(disposeBag)
        
        viewModel.repeatPasswordUsable
        .bind(to: repeatPasswordLabel.rx.validateResult)
        .addDisposableTo(disposeBag)
        
        //控制按钮是否可用
        viewModel.registButtonEnable
        .subscribe(onNext: { (vaild) in
            
            self.registerButton.isEnabled = vaild
            self.registerButton.alpha = vaild ? 1.0 : 0.5
            
        }).addDisposableTo(disposeBag)
        
        //控制输入框是否能输入
//        viewModel.usernameUsable
//        .bind(to: passwordTextField.rx.inputEnable)
//        .addDisposableTo(disposeBag)
        
        viewModel.usernameUsable
        .subscribe(onNext: { (result) in
            
            self.passwordTextField.isEnabled = result.isVaild
            
        }).addDisposableTo(disposeBag)
        
//        viewModel.passwordUsable
//        .subscribe(onNext: { (result) in
//            
//            self.repeatPasswordTextField.isEnabled = result.isVaild
//            
//        }).addDisposableTo(disposeBag)
        
        viewModel.passwordUsable
        .bind(to: repeatPasswordTextField.rx.inputEnable)
        .addDisposableTo(disposeBag)
        
        registerButton.rx.tap
        .bind(to: viewModel.registerTaps)
        .addDisposableTo(disposeBag)
        
        
        viewModel.registResult
        .subscribe(onNext: { (result) in
            switch result {
            case let .ok(message):
                self.showAlert(message: message)
            case .empty:
                self.showAlert(message: "")
            case let .failed(message):
                self.showAlert(message: message)
            }
        }).addDisposableTo(disposeBag)
        
    }
    
    func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
        
    }
  

}

