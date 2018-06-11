//
//  MyLayer.swift
//  CoreAnimation
//
//  Created by weizhen on 2018/5/31.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class MyLayer: CALayer {
    
    @objc var favorability : CGFloat = 0.0
    
    override class func needsDisplay(forKey key: String) -> Bool {
        
        if key == "favorability" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    func pause() {
        let beginTime = self.beginTime
        let timeOffset = self.timeOffset
        // 手机从开机一直到当前所经过的秒数。
        let mediaTime = CACurrentMediaTime()
        // 可以理解为: 计算mediaTime对应的图层时间, 这个计算会受到speed、timeOffset、beginTime三个参数的影响. 细心观察会发现, 本例中计算时均保持了speed=1、timeOffset=0、beginTime每次暂停都会增加
        let layerTime = convertTime(mediaTime, from: nil)
        self.speed      = 0.0
        self.timeOffset = layerTime
        self.beginTime  = 0.0
        NSLog("\(#function) old = {beginTime: %.4f, timeOffset: %.4f}, new = {beginTime: %.4f, timeOffset: %.4f}", beginTime, timeOffset, self.beginTime, self.timeOffset)
    }
    
    func resume() {
        let beginTime = self.beginTime
        let timeOffset = self.timeOffset
        self.speed      = 1.0
        self.timeOffset = 0.0
        let sincePause = convertTime(CACurrentMediaTime(), from: nil) - timeOffset
        self.beginTime  = sincePause
        NSLog("\(#function) old = {beginTime: %.4f, timeOffset: %.4f}, new = {beginTime: %.4f, timeOffset: %.4f}", beginTime, timeOffset, self.beginTime, self.timeOffset)
    }
}
