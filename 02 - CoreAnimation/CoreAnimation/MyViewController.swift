//
//  MyViewController.swift
//  CoreAnimation
//
//  Created by weizhen on 2018/5/31.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, CAAnimationDelegate, CALayerDelegate {
    
    let coordinates = [CGPoint(x:  50, y:  90),
                       CGPoint(x:  50, y: 230),
                       CGPoint(x:  90, y: 270),
                       CGPoint(x: 230, y: 270),
                       CGPoint(x: 270, y: 230),
                       CGPoint(x: 270, y:  90),
                       CGPoint(x: 230, y:  50),
                       CGPoint(x:  90, y:  50),
                       CGPoint(x:  50, y:  90)]
    
    let scheduleLayer = MyLayer()
    
    let AnimationKey = "mylayer.animation.favorability"
    
    var animationSpeed : Double = 100.0 // 每秒100个点的速度
    
    @IBOutlet var target : UIImageView!
    
    @IBOutlet var toResumeOrPause : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (view as! MyView).points = coordinates

        scheduleLayer.frame = view.bounds
        scheduleLayer.delegate = self
        view.layer.addSublayer(scheduleLayer)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        guard let prelayer = scheduleLayer.presentation() else { return }
        guard let anim = anim as? CAKeyframeAnimation, anim.keyPath == "favorability" else { return }
        NSLog("start   layer = {favorability: %.4f}, scheduleLayer = {favorability: %.4f, beginTime: %.4f, timeOffset: %.4f}", prelayer.favorability, scheduleLayer.favorability, scheduleLayer.beginTime, scheduleLayer.timeOffset)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let prelayer = scheduleLayer.presentation() else { return }
        guard let anim = anim as? CAKeyframeAnimation, anim.keyPath == "favorability" else { return }
        NSLog("stop    layer = {favorability: %.4f}, scheduleLayer = {favorability: %.4f, beginTime: %.4f, timeOffset: %.4f}, finished=%d", prelayer.favorability, scheduleLayer.favorability, scheduleLayer.beginTime, scheduleLayer.timeOffset, flag)
        scheduleLayer.removeAnimation(forKey: AnimationKey)
        toResumeOrPause.isSelected = false
    }
    
    func display(_ layer: CALayer) {
        guard let layer = layer as? MyLayer else { return }
        guard let prelayer = layer.presentation() else { return }
        NSLog("display layer = {favorability: %.4f}, scheduleLayer = {favorability: %.4f, beginTime: %.4f, timeOffset: %.4f}", prelayer.favorability, layer.favorability, layer.beginTime, layer.timeOffset)
        updateFrame(at: prelayer.favorability)
    }
    
    func updateFrame(at index: CGFloat) {
        
        if index == CGFloat(coordinates.count - 1) {
            target.center = coordinates.last!
            return
        }
        
        let foIndex = floor(index)
        let toIndex = foIndex + 1.0
        let foPoint = coordinates[Int(foIndex)]
        let toPoint = coordinates[Int(toIndex)]
        
        let current = CGPoint(x: foPoint.x + (toPoint.x - foPoint.x) * (index - foIndex), y: foPoint.y + (toPoint.y - foPoint.y) * (index - foIndex))
        target.center = current
        
        let dx = toPoint.x - foPoint.x
        let dy = toPoint.y - foPoint.y
        let direction = (dy > 0) ? CGFloat(Double.pi)-asin(dx/sqrt(dx*dx+dy*dy)) : asin(dx/sqrt(dx*dx+dy*dy))
        target.transform = CGAffineTransform(rotationAngle: direction)
    }
    
    @IBAction func sliderTouchUp(_ sender: UISlider) {
        
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func toResumeOrPause(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == false {
            
            scheduleLayer.pause() // 在`animationDidStop`的时候, 动画被移除掉, 并且设置了`isSelect=false`, 所以这里不用考虑
            
        } else if scheduleLayer.animation(forKey: AnimationKey) != nil {
            
            scheduleLayer.resume()
            
        } else {
            
            let animation = CAKeyframeAnimation(keyPath: "favorability")
            animation.values = Array(0..<coordinates.count)
            animation.keyTimes = [0.000, 0.125, 0.250, 0.375, 0.500, 0.625, 0.750, 0.875, 1.000]
            animation.duration = 8.0
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            animation.delegate = self
            scheduleLayer.add(animation, forKey: AnimationKey)
            
            NSLog("\(#function) animation = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}, layer = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}", animation.speed, animation.beginTime, animation.timeOffset, scheduleLayer.speed, scheduleLayer.beginTime, scheduleLayer.timeOffset)
        }
    }
    
    @IBAction func lastPoint(_ sender: UIButton) {
        let speed = scheduleLayer.speed
        let beginTime = scheduleLayer.beginTime
        let timeOffset = scheduleLayer.timeOffset
        let layerTime = scheduleLayer.convertTime(CACurrentMediaTime(), from: nil)
        scheduleLayer.speed      = 0.0
        scheduleLayer.timeOffset = layerTime + 1.0
        scheduleLayer.beginTime  = 0.0
        NSLog("\(#function) old = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}, new = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}", speed, beginTime, timeOffset, scheduleLayer.speed, scheduleLayer.beginTime, scheduleLayer.timeOffset)
    }
    
    @IBAction func nextPoint(_ sender: UIButton) {
        let speed = scheduleLayer.speed
        let beginTime = scheduleLayer.beginTime
        let timeOffset = scheduleLayer.timeOffset
        let layerTime = scheduleLayer.convertTime(CACurrentMediaTime(), from: nil)
        scheduleLayer.speed      = 0.0
        scheduleLayer.timeOffset = layerTime + 1.0
        scheduleLayer.beginTime  = 0.0
        NSLog("\(#function) old = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}, new = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}", speed, beginTime, timeOffset, scheduleLayer.speed, scheduleLayer.beginTime, scheduleLayer.timeOffset)
    }
    
    @IBAction func speedFast(_ sender: UIButton) {
        let speed = scheduleLayer.speed
        let beginTime = scheduleLayer.beginTime
        let timeOffset = scheduleLayer.timeOffset
        scheduleLayer.speed = 1.1
        NSLog("\(#function) old = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}, new = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}", speed, beginTime, timeOffset, scheduleLayer.speed, scheduleLayer.beginTime, scheduleLayer.timeOffset)
    }
    
    @IBAction func speedSlow(_ sender: UIButton) {
        let speed = scheduleLayer.speed
        let beginTime = scheduleLayer.beginTime
        let timeOffset = scheduleLayer.timeOffset
        scheduleLayer.speed = 0.9
        NSLog("\(#function) old = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}, new = {speed: %.2f, beginTime: %.4f, timeOffset: %.4f}", speed, beginTime, timeOffset, scheduleLayer.speed, scheduleLayer.beginTime, scheduleLayer.timeOffset)
    }
}

/*
 总结:
 01. 创建animation时设定好各项参数, 被添加到layer后, 就不能更改(比如想让speed=2来加速, 会出现软件崩溃)
 02. animation被添加到layer后, layer上的speed可以更改, 但是会导致动画迅速跑完(why?)
 03. 注意layer和animation都实现了CAMediaTiming协议, animation的时间都是相对于layer的
 04. animation无法报告动画进度, 本例中通过自定义的favorability, 来实现进度
 05. 动画开始后会生成一个presentation图层, 人眼看到的其实是它, 动画的参数变化其实发生在它的身上, 原本的图层仍然保存的是初始值
 */
