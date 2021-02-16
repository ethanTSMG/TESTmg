//
//  BMGListModel.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/16.
//

import UIKit

public class ListItem: BaseItem {
    
    public var terms: String?
    
    public var date: String?
    
    public var privacy: String?
    
    public var timestamp: String?
    
    public var source: String?
    
    public var quotes: [QuoteMapItem]?
}

public class QuoteMapItem: BaseItem {
    
    static func make(k: String, v: Any?) -> Self {
        let item = QuoteMapItem()
        item.key = k
        item.value = v
        return item as! Self
    }
    
    public var key: String = ""
    
    public var value: Any?
    
    public var doubleValue: Double {
        guard let res = value as? Double else { return 0 }
        return res
    }
}
