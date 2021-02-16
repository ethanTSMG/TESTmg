//
//  BMGNetworking.swift
//  base Networker
//
//  Created by hmarker on 2021/2/15.
//

import UIKit
import Moya
import HandyJSON
import CommonCrypto

public typealias NetworkCancellable = Cancellable

public let Networker: NetworkCenter = NetworkCenter.default

public class NetworkCenter: NSObject {
    
    /// 配置服务器地址
    @objc public var baseURL: URL?
    
    /// 请求超时时间，默认30s
    @objc public var timeoutInterval: TimeInterval = 30
    
    /// 是否显示网络状态指示器
    @objc public var activityIndicatorVisible = true
    
    /// 请求头是否加签
    @objc public var headerSigned = true
    
    /// 是否输出请求日志(全局控制，优先级最高)
    @objc public var debugLogEnabled = true
    
    /// 用于请求公共入参
    @objc public var baseParametersClosure: ((BaseRequest) -> (BaseReqParameters)?)?
    
    /// 用于响应公共事件
    @objc public var baseResponseClosure: ((BaseResponse) -> (Void))?
    
    /// oc桥接
    @objc static func sharedInstance() -> NetworkCenter {
        return NetworkCenter.default
    }
    
    fileprivate static let `default` = { NetworkCenter() }()
  
    fileprivate var _provider: MoyaProvider<BaseRequest>!
    
    fileprivate override init() {
        _provider = MoyaProvider<BaseRequest>(endpointClosure: ATNetworkConfig.endpointClosure,
                                                requestClosure: ATNetworkConfig.requestClosure,
                                                plugins: [ATNetworkConfig.activityPlugin,
                                                          ATNetworkConfig.loggerPlugin])
    }
}

/// 配置公用参数
public class BaseReqParameters: NSObject {
    
    /// AccessKey
    public var accessKey: String!

    /// 指定初始化器
    public init(accessKey: String?) {
        self.accessKey = accessKey
    }
}

// MARK: 请求入口
public extension NetworkCenter {
    
    /// 发送请求，响应成功和失败闭包
    @discardableResult
    func send(_ request: BaseRequest,
              _ success: @escaping (_ result: BaseResponse) -> Void,
              _ failure: ((_ result: BaseResponse) -> Void)?) -> NetworkCancellable {
        var _cancellable: NetworkCancellable?
        _cancellable = _provider.request(request) { (anyObj) in
            let response = BaseResponse()
            switch anyObj {
            case let .success(value):
                func callback(_ _data: Any?) {
                    DispatchQueue.global().async {
                        request.parseResponseAsync(data: _data) { (item) in
                            response.result = item
                            if let cancel = _cancellable, !cancel.isCancelled {
                                DispatchQueue.main.async { success(response) }
                            }
                        }
                    }
                }
                response.succeeded = true
                response.statusCode = value.statusCode
                let data = try? value.mapJSON()
                if let dict = data as? [String: Any] {
                    response.message = dict["privacy"] as? String
                    response.rawResult = dict
                    callback(response.rawResult)
                } else {
                    response.message = value.description
                    callback(data)
                }
            case let .failure(error):
                response.succeeded = false
                response.errorCode = error.errorCode
                response.errorInfo = error.errorUserInfo
                failure?(response)
            }
            Networker.baseResponseClosure?(response)
        }
        return _cancellable!
    }
    
    /// 取消所有请求
    func cancelAll() {
        _provider.session.cancelAllRequests()
    }
}

// MARK: 请求基类
public class BaseRequest: NSObject, TargetType {
    
    public override init() {}
    
    /// 基地址
    public var baseURL: URL {
        return Networker.baseURL ?? URL(string: "http://api.currencylayer.com")!
    }
    
    /// 基于baseURL的相对路径
    public var path: String {
        return pathName.rawValue
    }
    
    /// 请求方式
    public var method: Moya.Method {
        return .get
    }
    
    /// 测试用例
    public var sampleData: Data {
        return Data()
    }
    
    /// 请求头信息
    public var headers: [String : String]? {
        return httpHeaders()
    }
    
    /// 请求路径名称
    public var pathName: resourceType {
        return .none
    }
    
    /// 请求参数
    public var parameters: [String: Any] {
        return [:]
    }
    
    /// 会话任务
    public var task: Task {
        switch method {
        case .post:
            let options = JSONEncoding(options: JSONSerialization.WritingOptions())
            return .requestCompositeParameters(bodyParameters: readParameters, bodyEncoding: options, urlParameters: [:])
        default:
            return .requestParameters(parameters: readParameters, encoding: URLEncoding.default)
        }
    }
    
    /// 网络状态指示器
    public var activityIndicatorVisible = true
    
    /// 是否打印网络日志
    public var debugLogEnabled = true
    
    /// 请求入参
    public final var readParameters: [String: Any] {
        return appedParameters(parameters)
    }
    
    /// 请求入参(包含请求头信息)
    public final var readAllParameters: [String: Any] {
        var params = readParameters
        headers?.forEach({ (key, value) in
            params.updateValue(value, forKey: key)
        })
        return params
    }
    
    /// 响应数据：子类重写实现解析
    public func parseResponseAsync(data: Any?, finished: @escaping (Any?) -> Void) {}
    
    /// 参数对象 (若不是同一参数字典对象，会存在序列化后的josn字符串顺序不一致问题)
    private lazy var bodyParameters: [String: Any] = { [String: Any]() }()
}

// MARK: 响应基类
public class BaseResponse: NSObject {
    
    /// 数据主体(映射模型后的数据)
    @objc public var result: Any?
    
    /// 原始数据(未做映射的原始数据)
    @objc public var rawResult: Any?
    
    /// 是否成功响应
    @objc public var succeeded = false
    
    /// http状态码 (200成功=>succeeded为true)
    @objc public var statusCode: Int = -1 /// 1xx临时响应 2xx响应成功 3xx重定向 4xx请求错误 5xx服务器错误
    
    /// 业务信息
    @objc public var message: String?
    
    /// 请求错误状态码
    @objc public var errorCode: Int = -1
    
    /// 请求错误信息
    @objc public var errorInfo: [String : Any]?
}

// MARK: 数据模型基类
public class BaseItem: HandyJSON {
    
    required public init() {}
    
    /// 子类重写实现自定义解析规则
    public func mapping(mapper: HelpingMapper) {}
}


// MARK: - private -

private extension BaseRequest {
    
    /// 配置公用参数
    func appedParameters(_ values: [String: Any]) -> [String: Any] {
        if let result = Networker.baseParametersClosure?(self) {
            bodyParameters.updateValue(result.accessKey!, forKey: "access_key")
        }
        
        for element in values {
            bodyParameters.updateValue(element.value, forKey: element.key)
        }
        return bodyParameters
    }
    
    /// 设置请求头
    func httpHeaders() -> [String: String] {
        let headers = [String: String]()
        return headers
    }
}

// MARK: Log插件
private final class ATNetworkLogPlugin: PluginType {
    
    typealias NetworkLoggerClosure = (_ target: TargetType, _ result: Result<Moya.Response, MoyaError>?) -> Void
    let loggerClosure: NetworkLoggerClosure
    init(networkLoggerClosure: @escaping NetworkLoggerClosure) {
        loggerClosure = networkLoggerClosure
    }
        
    /// 请求前准备处理(修改request)
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

    /// 请求前事件处理
    public func willSend(_ request: RequestType, target: TargetType) {
        loggerClosure(target, nil)
    }

    /// 收到响应后事件处理
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        loggerClosure(target, result)
    }

    /// 回调结果前事件处理(修改result)
    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}

// MARK: 请求配置
private struct ATNetworkConfig {
    
    /// 定制请求头相关信息
    static let endpointClosure = { (target: BaseRequest) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        let endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        return endpoint
    }
    
    /// 定制URLRequest相关属性
    static let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<BaseRequest>.RequestResultClosure) in
        do {
            var urlRequest: URLRequest = try endpoint.urlRequest()
            urlRequest.httpShouldHandleCookies = false /// 禁用请求cookie
            urlRequest.timeoutInterval = Networker.timeoutInterval
            done(.success(urlRequest))
        } catch {
            done(.failure(MoyaError.requestMapping(endpoint.url)))
        }
    }
    
    /// 定义网络状态指示器
    static let activityPlugin = NetworkActivityPlugin { (state, target) in
        guard Networker.activityIndicatorVisible, let res = target as? BaseRequest, res.activityIndicatorVisible else { return }
        func showIndicator(_ visible: Bool) {
            ATNetworkUtility.runInMain {
                UIApplication.shared.isNetworkActivityIndicatorVisible = visible
            }
        }
        switch state {
        case .began:
            showIndicator(res.activityIndicatorVisible)
        case .ended:
            showIndicator(false)
        }
    }
    
    /// 网络日志提示
    static let loggerPlugin = ATNetworkLogPlugin { (target, result) in
        guard Networker.debugLogEnabled else { return }
        guard let g = target as? BaseRequest, g.debugLogEnabled else { return }
        switch result {
        case .none:
            ATNetworkLog.log("\n╔\(ATNetworkLog.boundaries)")
            ATNetworkLog.log("║SEND：🚀\n║\(g.baseURL.absoluteString + g.path)")
            ATNetworkLog.log("║INFO：\n\(ATNetworkUtility.toString(g.readAllParameters, type: .prettySortedKeys))")
            ATNetworkLog.log("╚\(ATNetworkLog.boundaries)\n")
        case let .success(value):
            let data = try? value.mapJSON()
            ATNetworkLog.log("\n╔\(ATNetworkLog.boundaries)")
            ATNetworkLog.log("║SUCCESS：🍻\n║\(g.baseURL.appendingPathComponent(g.path).absoluteString)")
            ATNetworkLog.log("║INPUT：👉🏻\n\(ATNetworkUtility.toString(g.readParameters, type: .prettySortedKeys))")
            ATNetworkLog.log("║RESP：👉🏻\n\(ATNetworkUtility.toString(data ?? "data is empty.", type: .prettySortedKeys))")
            ATNetworkLog.log("╚\(ATNetworkLog.boundaries)\n")
        case let .failure(error):
            ATNetworkLog.log("\n╔\(ATNetworkLog.boundaries)")
            ATNetworkLog.log("║FAILURE：❗️\n║\(error.localizedDescription)")
            ATNetworkLog.log("║URL：\n║\(g.baseURL.absoluteString + g.path)")
            ATNetworkLog.log("║INPUT：\n║\(ATNetworkUtility.toString(g.readAllParameters, type: .prettySortedKeys))")
            ATNetworkLog.log("║ERROR：\n║\(error.errorUserInfo)")
            ATNetworkLog.log("╚\(ATNetworkLog.boundaries)\n")
        }
    }
}

// MARK: 工具类
private struct ATNetworkUtility {
    
    /// Json解析类型
    enum JSONWritingType {
        case defalut, prettyPrinted, prettySortedKeys
    }
    
    /// 转Json字符串
    static func toString(_ object: Any, type: JSONWritingType = .defalut) -> String {
        let options: JSONSerialization.WritingOptions
        switch type {
        case .defalut:
            options = JSONSerialization.WritingOptions()
        case .prettyPrinted:
            options = .prettyPrinted
        case .prettySortedKeys:
            if #available(iOS 11.0, *) {
                options = [.sortedKeys, .prettyPrinted]
            } else {
                options = .prettyPrinted
            }
        }
        return toJosnString(object, options: options)
    }
    
    /// 转Json字符串
    static func toJosnString(_ object: Any, options: JSONSerialization.WritingOptions = []) -> String {
            guard JSONSerialization.isValidJSONObject(object) else { return "" }
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: options) else { return "" }
            return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// 主线程操作
    static func runInMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async { work() }
        }
    }
}

// MARK: Debug输出
private struct ATNetworkLog {
    static func log(_ items: Any, separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        print(items, separator: separator, terminator: terminator)
        #endif
    }
    
    static var boundaries: String = {
        var s = ""
        repeat { s += "═" } while s.count < 80
        return s
        
    } ()
}
