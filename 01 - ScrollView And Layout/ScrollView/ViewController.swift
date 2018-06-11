//
//  ViewController.swift
//  ScrollView
//
//  Created by weizhen on 2018/6/7.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    var labelWidthConstraint : NSLayoutConstraint!
    
    var labelHeightConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .gray
        scrollView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        scrollView.drawBorder()
        view.addSubview(scrollView)

        // UIScrollView本身的布局, 与内部视图无关
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let segmented1 = UISegmentedControl(items: ["收缩", "展开"])
        segmented1.translatesAutoresizingMaskIntoConstraints = false
        segmented1.selectedSegmentIndex = 0
        segmented1.tag = 10000
        segmented1.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)
        scrollView.addSubview(segmented1)
        
        let textLabel1 = UILabel()
        textLabel1.translatesAutoresizingMaskIntoConstraints = false
        textLabel1.backgroundColor = .red
        textLabel1.text = "将会变宽"
        textLabel1.textAlignment = .center
        textLabel1.drawBorder()
        scrollView.addSubview(textLabel1)
        
        let segmented2 = UISegmentedControl(items: ["收缩另一个", "展开另一个"])
        segmented2.translatesAutoresizingMaskIntoConstraints = false
        segmented2.tag = 10001
        segmented2.selectedSegmentIndex = 0
        segmented2.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)
        scrollView.addSubview(segmented2)
        
        let textLabel2 = UILabel()
        textLabel2.translatesAutoresizingMaskIntoConstraints = false
        textLabel2.backgroundColor = .red
        textLabel2.text = "将会变高"
        textLabel2.textAlignment = .center
        textLabel2.drawBorder()
        scrollView.addSubview(textLabel2)
        
        segmented1.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        segmented1.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        textLabel1.topAnchor.constraint(equalTo: segmented1.bottomAnchor).isActive = true
        textLabel1.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        labelWidthConstraint = textLabel1.widthAnchor.constraint(equalToConstant: 300)
        
        segmented2.topAnchor.constraint(equalTo: textLabel1.bottomAnchor).isActive = true
        segmented2.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        textLabel2.topAnchor.constraint(equalTo: segmented2.bottomAnchor).isActive = true
        textLabel2.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        labelHeightConstraint = textLabel2.heightAnchor.constraint(equalToConstant: 300)
        
        // 如果仅仅使用上面的约束, 会发现contentSize总是(0.0, 0.0)
        // 补充下面的约束, contentSize终于有值了, 并且宽高与对应label的宽高相关
        textLabel1.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        textLabel2.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // UIScrollView布局总结
        // 01.布局subview时, 假设scrollview处于没有偏移的状态.
        // 02.关于contentSize, 以width为例:
        //   设置subview与scrollview的left & width & right关系, 可以确定contentSize.width;
        //   所有设定了这个关系的subview中, contentSize.width取其中的subview.width的最大值, 然后较小的subview.width会调整自己的宽度, 以保证关系正确.
        // 03.如果设置了contentInset, ???
    }
    
    @objc func segmentedChanged(_ sender: UISegmentedControl) {
        
        let constraint = (sender.tag == 10000) ? labelWidthConstraint : labelHeightConstraint
        let isActive = (sender.selectedSegmentIndex != 0)
        NSLog("began scrollView: contentSize = \(scrollView.contentSize), contentOffset = \(scrollView.contentOffset)")
        
        UIView.animate(withDuration: 2, animations: {
            constraint?.isActive = isActive
            self.scrollView.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            NSLog("ended scrollView: contentSize = \(self.scrollView.contentSize), contentOffset = \(self.scrollView.contentOffset)")
        })
    }
}

extension UIView {
    
    func drawBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blue.cgColor
    }
}


