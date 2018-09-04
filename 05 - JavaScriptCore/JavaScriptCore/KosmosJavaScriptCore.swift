//
//  KosmosJavaScriptCore.swift
//  KosmosJavaScriptCore
//
//  Created by weizhen on 2018/7/11.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import JavaScriptCore

extension JSContext {
    
    func install() {
        
        /* Console */
        let console = Console()
        setObject(console, forKeyedSubscript: "console" as NSCopying & NSObjectProtocol)
        
        /* XMLHttpRequest */
        setObject(XMLHttpRequest.self, forKeyedSubscript: "XMLHttpRequest" as NSCopying & NSObjectProtocol)
        
        /* Functions */
        let eval : @convention(block) (String)->JSValue? = { str in
            return JSContext.current().evaluateScript(str)
        }
        setObject(eval, forKeyedSubscript: "eval" as NSCopying & NSObjectProtocol)
    }
    
    @discardableResult
    func invokeMethod(_ method: String!, withArguments arguments: [Any]!, inObject object: String!) -> JSValue! {
        
        if let object = object {
            return objectForKeyedSubscript(object)?.invokeMethod(method, withArguments: arguments)
        } else {
            return objectForKeyedSubscript(method)?.call(withArguments: arguments)
        }
    }
}

extension JSValue {
    
    open override var description: String {
        if self.isNull { return "(Null)null" }
        if self.isNumber { return "(Number)\(toNumber())" }
        if self.isString { return "(String)\(toString())" }
        if self.isDate { return "(Date)\(toDate())" }
        if self.isUndefined { return "(Undefined)Undefined" }
        if self.isBoolean { return "(Boolean)\(toBool())" }
        if self.isArray { return "(Array)\(toArray())" }
        if self.isObject { return "(Object)\(toObject())" }
        return "(Unknown)\(self)"
    }
}

@objc protocol ConsoleInJS : JSExport {
    
    func log(_ format: String)
}

@objc class Console : NSObject, ConsoleInJS {
    
    func log(_ format: String) {
        print(format)
    }
}

@objc protocol XMLHttpRequestInJS : JSExport {
    
    var onreadystatechange : JSValue? { get set }
    
    var readyState : Int { get }
    
    var status : Int { get }
    
    var statusText : String { get }
    
    var responseText : String { get }
    
    init()
    
    func open(_ method: String, _ url: String, _ async: Bool)
    
    func send()
    
    func overrideMimeType(_ mime: String)
}

@objc class XMLHttpRequest : NSObject, URLSessionDataDelegate, XMLHttpRequestInJS {
    
    var onreadystatechange : JSValue?
    
    /**
     - 0 UNSENT           (未打开) open()方法还未被调用.
     - 1 OPENED           (未发送) open()方法已经被调用.
     - 2 HEADERS_RECEIVED (已获取响应头) send()方法已经被调用, 响应头和响应状态已经返回.
     - 3 LOADING          (正在下载响应体) 响应体下载中; responseText中已经获取了部分数据.
     - 4 DONE             (请求完成) 整个请求过程已经完毕.
     */
    var readyState : Int = 0 {
        didSet {
            _ = onreadystatechange?.call(withArguments: [])
        }
    }
    
    /// 该请求的响应状态码 (例如, 状态码200 表示一个成功的请求).只读.
    var status : Int = 0
    
    /// 该请求的响应状态信息,包含一个状态码和原因短语 (例如 "200 OK"). 只读.
    var statusText : String = ""
    
    var responseText : String = ""
    
    var request : NSMutableURLRequest!
    
    var session : URLSession!
    
    var task: URLSessionDataTask!
    
    var allData: Data!
        
    override required init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func open(_ method: String, _ url: String, _ async: Bool) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        self.request = NSMutableURLRequest(url: url)
        self.request.httpMethod = method
        self.task = self.session.dataTask(with: self.request! as URLRequest)
        self.readyState = 1
    }
    
    func send() {
        self.task.resume()
    }
    
    func overrideMimeType(_ mime: String) {

    }
    
    // URLSessionDelegate
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        //print("didBecomeInvalidWithError error: \(error?.localizedDescription ?? "null")")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        //print("didReceive challenge: \(challenge)")
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        //print("forBackgroundURLSession session: \(session)")
    }
    
    // URLSessionTaskDelegate
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Swift.Void) {
        //print("willBeginDelayedRequest request: \(request)")
    }
    
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        //print("taskIsWaitingForConnectivity task: \(task)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Swift.Void) {
        //print("willPerformHTTPRedirection response: \(response), newRequest request: \(request)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        //print("didReceive challenge: \(challenge)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Swift.Void) {
        //print("needNewBodyStream completionHandler: \(completionHandler)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //print("didSendBodyData bytesSent: \(bytesSent), totalBytesSent: \(totalBytesSent), totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        //print("didFinishCollecting metrics: \(metrics)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        //print("didCompleteWithError error: \(error?.localizedDescription ?? "null")")
        
        if let error = error as NSError? {
            self.status = error.code
            self.statusText = error.localizedDescription
        }
        
        if let data = allData {
            let encodings = [String.Encoding.utf8, .GB18030]
            var string : String?
            for encoding in encodings {
                string = String(data: data, encoding: encoding)
                if string != nil { break }
            }
            self.responseText = string ?? ""
        }
        
        self.readyState = 4
    }
    
    // - URLSessionDataDelegate
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        //print("didReceive response: \(response)")
        
        let httpURLResponse = response as! HTTPURLResponse
        self.status = httpURLResponse.statusCode
        self.readyState = 2
        
        if httpURLResponse.statusCode != 200 {
            completionHandler(.cancel)
        } else {
            self.allData = Data()
            completionHandler(.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        //print("didBecome downloadTask: \(downloadTask)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        //print("didBecome streamTask: \(streamTask)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //print("didReceive data: \(data)")
        self.allData.append(data)
        self.readyState = 3
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Swift.Void) {
        //print("willCacheResponse proposedResponse: \(proposedResponse)")
        completionHandler(proposedResponse)
    }
}
