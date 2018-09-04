//
//  AppDelegate.swift
//  MultiPage
//
//  Created by weizhen on 2018/7/4.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let path = Bundle.main.url(forResource: "chapter", withExtension: "txt")!
        let data = try! Data(contentsOf: path)
        let text = String(data: data, encoding: .utf8)!
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = PageViewController(text: text, page: 1)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        return true
    }
}
