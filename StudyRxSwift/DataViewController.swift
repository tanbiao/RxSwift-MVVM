//
//  DataViewController.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/6.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class DataViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!


    @IBOutlet weak var dataTableView: UITableView!
    
    lazy var disposeBag = DisposeBag()
    
    var searchText : Observable<String>
    {
        return   searchBar.rx.text.orEmpty
            .throttle(10, scheduler: MainScheduler.instance).distinctUntilChanged()

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let viewModel = DataViewModel(searchText: searchText)
        
        dataTableView.rowHeight = 80
       
        viewModel.herosModel.drive(dataTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
           (index, hero ,cell) in
            
            cell.textLabel?.text = hero.name
            cell.detailTextLabel?.text = hero.intro
            cell.imageView?.image = UIImage(named: hero.icon)
        
        }.addDisposableTo(disposeBag)
        
        //选择的模型
        dataTableView.rx.modelSelected(Hero.self).subscribe(onNext: { (hero) in
            
            print("mode=====\(hero.name)")
            print(hero.intro)
            
        }).addDisposableTo(disposeBag)
        
        //选择的
        dataTableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            
            print("index=====\(indexPath.row)")
            
        }).addDisposableTo(disposeBag)
        
        dataTableView.rx.didScroll.subscribe(onNext: { [weak self](x) in
            print(self?.dataTableView.contentOffset.y)
            
        }, onError: { (error) in
            print(error)
        }, onCompleted: { 
            print("onCompleted")
        }).addDisposableTo(disposeBag)
        
    }

   

}
