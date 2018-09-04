//
//  AppDelegate.swift
//  JavaScriptCore
//
//  Created by weizhen on 2018/7/11.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit
import JavaScriptCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        example()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// 直接在Native代码中执行JS代码
    func example() {
        
        let machine = JSVirtualMachine()!
        
        // 新建的context并没有变量和函数
        let context = JSContext(virtualMachine: machine)!
        context.install()
        
        // 处理出错
        context.exceptionHandler = { context, exception in
            print("JS Error:\(exception?.description ?? "xxxx")")
        }
        
        // 执行一段具体的JavaScript代码, 往context里加变量、函数
        context.evaluateScript("var number = 22") // 添加Number
        context.evaluateScript("var array = ['apple','banana','watermelon']") // 添加Array
        context.evaluateScript("var fun = function(a,b) {return a + b}") // 添加Function
        context.evaluateScript("local".content) // 添加JavaScript代码
        
        /* Number */
        let key1 : String = "age"
        let obj1 : Int = 18
        context.setObject(obj1, forKeyedSubscript: key1 as NSCopying & NSObjectProtocol) // 在全局添加添加JavaScript代码: var age = 18;
        
        let object1 = context.objectForKeyedSubscript(key1)!
        print("\(key1) is \(object1)")
        
        context.evaluateScript("var anotherNumber = age + 30") // 通过Swift添加的变量age, 在JavaScript中是可以获取的
        let anotherNumber = context.objectForKeyedSubscript("anotherNumber")!
        print("anotherNumber is \(anotherNumber)")
        
        /* String */
        let key2 : String = "name"
        let obj2 : String = "Jack"
        context.setObject(obj2, forKeyedSubscript: key2 as NSCopying & NSObjectProtocol) // 在全局添加添加JavaScript代码: var name = "Jack";
        
        let object2 = context.objectForKeyedSubscript(key2)!
        print("\(key2) is \(object2)")
        
        /* Array */
        let key3 : String = "subjects"
        let obj3 = ["Math", "Chinese", "Physical", "Chemistry"]
        context.setObject(obj3, forKeyedSubscript: key3 as NSCopying & NSObjectProtocol) // 在全局添加添加JavaScript代码: var subjects = ['Math','Chinese','Physical','Chemistry'];
        
        let object3 = context.objectForKeyedSubscript(key3)!
        object3.setObject("Biology", atIndexedSubscript: 5) // 插入数据到数组. 注意index=4的位置自动补入了Undefined
        
        let item = object3.objectAtIndexedSubscript(4)! // 获取数组中的第一个元素
        print("\(key3) is \(object3), and item is \(item)")
        
        /* Function */
        let key4 : String = "getScore"
        let obj4 : @convention(block) (Int)->String = { num in
            return String(describing: num * 2)
        }
        context.setObject(obj4, forKeyedSubscript: key4 as NSCopying & NSObjectProtocol) // 在全局添加添加JavaScript代码: function getScore(){ /* anonymous code */; return "return a string" };
        
        let object4 = context.objectForKeyedSubscript(key4)! // 获取函数
        let object5 = object4.call(withArguments: [20, 30])! // 调用函数, 传入所需的参数
        print("\(key4).result is \(object5)")
        
        let object6 = context.evaluateScript("getScore(40, 50)")! // 另一种调用函数
        print("\(key4).result is \(object6)")
        
        /* Object x Class */
        context.invokeMethod("objectBySwift", withArguments: ["GET", "http://localhost/composer.json"], inObject: nil)        
        //context.invokeMethod("download", withArguments: ["http://www.166xs.com/xiaoshuo/76/76326/15991246.html"], inObject: nil)
    }
}

extension String {
    
    var content : String {
        let path = Bundle.main.url(forResource: self, withExtension: "js")!
        return try! String(contentsOf: path)
    }
}


extension String.Encoding {
    
    /// GB18030
    public static var GB18030: String.Encoding  = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}
