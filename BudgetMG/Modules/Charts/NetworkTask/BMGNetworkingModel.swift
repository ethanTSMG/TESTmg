//
//  BMGNetworkingModel.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/15.
//

//请求类型
public enum resourceType: String {
    
    case none = ""
    
    case live = "/live"
    
    case historical = "/historical"
    
    case convert = "/convert"
}
