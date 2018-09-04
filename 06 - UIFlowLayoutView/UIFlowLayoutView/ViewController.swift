//
//  ViewController.swift
//  UIFlowLayoutView
//
//  Created by weizhen on 2018/8/16.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIFlowLayoutViewDelegate, MyFlowLayoutViewCell2Delegate {
    
    let labels = ["不限", "仙侠", "修真", "军事", "历史", "同人", "恐怖故事", "悬疑的激情", "武侠Wuxia", "玄幻", "奇幻", "魔法", "科幻", "穿越", "重生", "网游", "动漫", "都市", "言情", "校园", "其他"]
    
    let flowLayout = UIFlowLayoutView()
    
    var marginRight : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switc = UISwitch()
        switc.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        switc.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        view.addSubview(switc)
        
        flowLayout.translatesAutoresizingMaskIntoConstraints = false
        flowLayout.direction = .horizontal
        flowLayout.interitemSpacing = 2
        flowLayout.lineSpacing = 2
        flowLayout.delegate = self
        flowLayout.backgroundColor = .yellow
        flowLayout.register(MyFlowLayoutViewCell1.self, forCellWithReuseIdentifier: MyFlowLayoutViewCell1.defaultIdentifier)
        flowLayout.register(MyFlowLayoutViewCell2.self, forCellWithReuseIdentifier: MyFlowLayoutViewCell2.defaultIdentifier)
        view.addSubview(flowLayout)
        
        NSLayoutConstraint(item: flowLayout, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 110).isActive = true
        NSLayoutConstraint(item: flowLayout, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 10).isActive = true
        //NSLayoutConstraint(item: flowLayout, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        marginRight = NSLayoutConstraint(item: flowLayout, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -10)
        marginRight.isActive = true
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        
        UIView.animate(withDuration: 0.5) {
        
            if sender.isOn {
                self.marginRight.constant = -110
            } else {
                self.marginRight.constant = -10
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func numberOfItems(in flowLayoutView: UIFlowLayoutView) -> Int {
        return labels.count
    }
    
    func flowLayoutView(_ flowLayoutView: UIFlowLayoutView, cellForItemAt index: Int) -> UIFlowLayoutViewCell {
        
        if index % 2 == 0 {
            let cell = flowLayoutView.dequeueReusableCell(withReuseIdentifier: MyFlowLayoutViewCell1.defaultIdentifier, for: index) as! MyFlowLayoutViewCell1
            cell.label.text = labels[index]
            return cell
        } else {
            let cell = flowLayoutView.dequeueReusableCell(withReuseIdentifier: MyFlowLayoutViewCell2.defaultIdentifier, for: index) as! MyFlowLayoutViewCell2
            let text = labels[index]
            cell.label.setTitle(text, for: .normal)
            cell.delegate = self
            return cell
        }
    }
    
    func flowLayoutView(_ flowLayoutView: UIFlowLayoutView, didSelectItemAt index: Int) {
        let text = labels[index]
        NSLog("\(#function) didSelectItemAt \(index) \(text)")
    }
    
    func flowLayoutViewCell2(_ sender: MyFlowLayoutViewCell2) {
        let text = sender.label.title(for: .normal) ?? "null"
        NSLog("\(#function) didSelectItemAt \(index) \(text)")
    }
}

class MyFlowLayoutViewCell1: UIFlowLayoutViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .brown
        contentView.addSubview(label)
        
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyFlowLayoutViewCell2: UIFlowLayoutViewCell {
    
    let label = UIButton()
    
    weak var delegate : MyFlowLayoutViewCell2Delegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        label.contentHorizontalAlignment = .center
        label.setTitleColor(.black, for: .normal)
        label.backgroundColor = .brown
        label.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        contentView.addSubview(label)
        
        NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTap(_ sender: UIButton) {
        delegate?.flowLayoutViewCell2(self)
    }
}

protocol MyFlowLayoutViewCell2Delegate : NSObjectProtocol {
    
    func flowLayoutViewCell2(_ sender: MyFlowLayoutViewCell2)
}
