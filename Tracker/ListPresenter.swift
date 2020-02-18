//
//  ListPresenter.swift
//  Tracker
//
//  Created by Youngho Oh on 2020/02/02.
//  Copyright © 2020 Youngho Oh. All rights reserved.
//

import UIKit
import Photos

protocol ListPresentationprotocol {
    func fetchData() -> [List]?
    func setNewData()
    func clearData()
}

class ListPresenter: ListPresentationprotocol {
    //MARK: [Property]
    weak var viewController:  ListProtocol?
    var interator: ListInterator?
    
    //MARK: [Method]
    func fetchData() -> [List]? {
        return interator?.getListData()
    }
    
    func setNewData() {
        var estimatedCount = 0
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        collections.enumerateObjects { (collection, idx, stop) in
            estimatedCount += collection.estimatedAssetCount
        }
        
        interator?.setData(count: Double(estimatedCount))
    }
    
    func clearData() {
        interator?.clearData()
    }
}
