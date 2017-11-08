//
//  DataViewModel.swift
//  StudyRxSwift
//
//  Created by 谭彪 on 2017/11/6.
//  Copyright © 2017年 谭彪. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DataViewModel
{
    var herosModel : Driver<[Hero]>
    
    init(searchText:Observable<String>)
    {
        let queue = ConcurrentDispatchQueueScheduler(qos: .background)
        
        herosModel = searchText.debug().observeOn(queue).flatMap({ (text) -> Observable<[Hero]> in
            return DataService.instance.getHeros(searchText: text)
            
        }).asDriver(onErrorJustReturn: [])

    }
    
}
