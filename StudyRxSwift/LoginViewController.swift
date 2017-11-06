//
//  LoginViewController.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/2.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = (usernameTextField.rx.text.orEmpty.asDriver(),passwordTextField.rx.text.orEmpty.asDriver(),loginButton.rx.tap.asDriver())
        
        let viewModel = LoginViewModel(input: input)
        
        viewModel.usernameUsable
        .drive(usernameLabel.rx.validateResult)
        .addDisposableTo(disposeBag)
        
        viewModel.loginButtonEnabled
        .drive(onNext: { (valid) in
            
            self.loginButton.isEnabled = valid
            self.loginButton.alpha = valid ? 1.0 : 0.5
            
        }).addDisposableTo(disposeBag)
        
        viewModel.loginResult
        .drive(onNext: { (result) in
            
            switch result {
            case let .ok(message):
                
                self.performSegue(withIdentifier: "data", sender: nil)
                
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
