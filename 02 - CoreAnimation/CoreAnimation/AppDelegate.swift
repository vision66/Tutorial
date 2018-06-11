//
//  AppDelegate.swift
//  CoreAnimation
//
//  Created by weizhen on 2018/5/31.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewController = MyViewController(nibName: "MyViewController", bundle: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }
}

