//
//  BMGChartsNetworkRequestExtension.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

// MARK: Live
public class LiveRequest: BaseRequest {
    
    public var source: String?

    public var format = 1
    
    /*
    // MARK: - override
    // To Do: Package
    */
    public override var pathName: resourceType {
        return .live
    }
    
    public override var parameters: [String : Any] {
        return ["source" : source ?? "",
                "format" : format]
    }
    
    public override func parseResponseAsync(data: Any?, finished: @escaping (Any?) -> Void) {
        guard let value = data as? [String: Any] else { return finished(nil) }
        let item = ListItem.deserialize(from: value)
        if let res = value["quotes"] as? [String : Any] {
            item?.quotes = res.map({QuoteMapItem.make(k: $0, v: $1)  })
        }
        finished(item)
    }
}

// MARK: Historical
public class HistoricalRequest: BaseRequest {
    
    public var source: String?
    
    public var date: String = "2020-02-19"
        
    public var format = 1
    
    /*
    // MARK: - override
    // To Do: Package
    */
    public override var pathName: resourceType {
        return .historical
    }
    
    public override var parameters: [String : Any] {
        return ["source" : source ?? "",
                "date" : date,
                "format" : format]
    }
    
    public override func parseResponseAsync(data: Any?, finished: @escaping (Any?) -> Void) {
        guard let value = data as? [String: Any] else { return finished(nil) }
        let item = ListItem.deserialize(from: value)
        if let res = value["quotes"] as? [String : Any] {
            item?.quotes = res.map({QuoteMapItem.make(k: $0, v: $1)  })
        }
        finished(item)
    }
}

// MARK: Convert
public class ConvertRequest: BaseRequest {
        
    public var format = 1
    
    public var from: String!
    
    public var to: String!
    
    public var amount = 200.0
    
    public var date: String = "2020-12-19"

    public override var pathName: resourceType {
        return .convert
    }
    
    /*
    // MARK: - override
    // To Do: Package
    */
    public override var parameters: [String : Any] {
        return [
                "format" : format,
                "from" : "USD",
                "to" : "NZD",
                "amount" : amount,
                "date" : date]
    }
    
    public override func parseResponseAsync(data: Any?, finished: @escaping (Any?) -> Void) {
        guard let value = data as? [String: Any] else { return finished(nil) }
        let item = ListItem.deserialize(from: value)
        if let res = value["quotes"] as? [String : Any] {
            item?.quotes = res.map({QuoteMapItem.make(k: $0, v: $1)  })
        }
        finished(item)
    }
}
