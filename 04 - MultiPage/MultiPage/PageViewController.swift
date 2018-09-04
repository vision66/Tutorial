//
//  PageViewController.swift
//  MultiPage
//
//  Created by weizhen on 2018/7/4.
//  Copyright © 2018年 Wuhan Mengxin Technology Co., Ltd. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    /// 完整内容
    private var fullContent = ""
    
    /// 分页内容
    private var pageContents = [NSMutableAttributedString]()
    
    /// 初始页码
    private var firstPage = 0
    
    init(text: String, page: Int) {
        self.fullContent = text
        self.firstPage = page
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.delegate = self
        self.dataSource = self
        
        let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.firstLineHeadIndent = 28 // 这个参数会影响布局, 不要设置它
        paragraphStyle.lineHeightMultiple = 1.5
        
        var attributes = [NSAttributedStringKey : Any]()
        attributes[NSAttributedStringKey.font] = UIFont(name: "Heiti SC", size: 14) // 这个参数会影响布局, 只能设置成某五种, 参考下面的链接
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.blue
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 80)
        
        pageContents = pagingWithContentString(fullContent, contentSize: size, attributes: attributes)
        
        // 将书翻到"这一页"
        let firstController = ViewController(content: pageContents[firstPage], index: firstPage)
        self.setViewControllers([firstController], direction: .forward, animated: false, completion: nil)
    }
    
    /// 利用TextKit分割文本, 参考: https://www.jianshu.com/p/f3251ea3da99
    func pagingWithContentString(_ content: String, contentSize: CGSize, attributes: [NSAttributedStringKey : Any]? = nil) -> [NSMutableAttributedString] {
        
        let attrContent = NSMutableAttributedString(string: content, attributes: attributes)
        
        let textStorage = NSTextStorage(attributedString: attrContent)
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        var attrPages = [NSMutableAttributedString]()
        
        while true {
            
            let textContainer = NSTextContainer(size: contentSize)
            layoutManager.addTextContainer(textContainer)
            
            let range = layoutManager.glyphRange(for: textContainer)
            if range.length <= 0 { break }
            
            let page = (content as NSString).substring(with: range)
            let attrPage = NSMutableAttributedString(string: page, attributes: attributes)
            attrPages.append(attrPage)
        }
        
        return attrPages
    }
    
    /// 缓存上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let current = viewController as! ViewController
        
        if current.pageIndex == 0 {
            print("缓存上一页, 当前页是第 \(current.pageIndex) 页, 上一页是第 x 页")
            return nil
        }
        
        let index = current.pageIndex - 1
        
        let next = ViewController(content: pageContents[index], index: index)
        print("缓存上一页, 当前页是第 \(current.pageIndex) 页, 上一页是第 \(next.pageIndex) 页")
        return next
    }
    
    /// 缓存下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let current = viewController as! ViewController
        
        if current.pageIndex == pageContents.count - 1 {
            print("缓存下一页, 当前页是第 \(current.pageIndex) 页, 下一页是第 x 页")
            return nil
        }
        
        let index = current.pageIndex + 1
        
        let next = ViewController(content: pageContents[index], index: index)
        print("缓存下一页, 当前页是第 \(current.pageIndex) 页, 下一页是第 \(next.pageIndex) 页")
        return next
    }
    
    /** 书脊的位置, 在旋转视图的时候会触发, 相当于一个布局回调
     *  当 transitionStyle != UIPageViewControllerTransitionStylePageCurl 时,
     *    返回 UIPageViewControllerSpineLocationNone, 其实无论返回什么都会被当做None
     *  当 transitionStyle == UIPageViewControllerTransitionStylePageCurl 时,
     *    返回 UIPageViewControllerSpineLocationMin, 则书脊在左侧或上侧, 并且必须包含一个视图
     *    返回 UIPageViewControllerSpineLocationMid, 则书脊在中间的位置, 并且必须包含两个视图
     *    返回 UIPageViewControllerSpineLocationMax, 则书脊在右侧或下侧, 并且必须包含一个视图
     */
    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        print("spineLocation for \(orientation)")
        return .min
    }
    
    /// 将要翻页时
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let firstPending = pendingViewControllers.first as! ViewController
        print("试图翻到第 \(firstPending.pageIndex) 页")
    }
    
    /// 正在翻页时. finished表示动画完成; completed表示这一页翻过去了, 如果completed=NO则是想要翻过去时却又退回来了
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let firstPrevious = previousViewControllers.first as! ViewController
        print("动画是否结束 \(finished); 翻页是否完成 \(completed); 发生动画前是第 \(firstPrevious.pageIndex) 页")
    }
}
