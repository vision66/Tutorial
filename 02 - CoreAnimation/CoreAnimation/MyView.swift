//
//  MyView.swift
//  CoreAnimation
//
//  Created by weizhen on 2018/6/1.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class MyView: UIView {

    var points = [CGPoint]()
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.addLines(between: points)
        ctx.setStrokeColor(UIColor.brown.cgColor)
        ctx.setLineWidth(2)
        ctx.strokePath()
    }
}
