//
//  BMGTransactionsItemModel.swift
//  TransactionsItem Model
//
//  Created by hmarker on 2021/2/16.
//

import UIKit

public class TransactionsItem: BaseItem {
    
    public var category: String?
    
    public var date: String?
    
    public var currency: String?
    
    public var value: String?
    
    init(date: String?, category: String?, currency: String?, value: String?) {
        self.category = category
        self.currency = currency
        self.date = date
        self.value = value
    }
    
    required public init() {}
}
