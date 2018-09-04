//
//  ViewController.swift
//  MultiPage
//
//  Created by weizhen on 2018/7/4.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let pageContent : NSAttributedString
    
    let pageIndex : Int
    
    init(content: NSAttributedString, index: Int) {
        self.pageContent = content
        self.pageIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let textView = UITextView()
        textView.frame = view.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.backgroundColor = UIColor.brown
        textView.contentInsetAdjustmentBehavior = .never
        textView.attributedText = pageContent
        view.addSubview(textView)
    }
}
