//
//  ViewController.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/1.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextF: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var disposeBag = DisposeBag()
    
    let username = Variable("")
    
    let select = PublishSubject<IndexPath>()
    
    var usernameUsable: Observable<String>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

