//
//  UIStackViewDocument.swift
//  aaa
//
//  Created by weizhen on 2018/2/26.
//  Copyright © 2018年 weizhen. All rights reserved.
//

import UIKit

public enum UIStackViewDistribution : Int {
    
    
    /* When items do not fit (overflow) or fill (underflow) the space available
     adjustments occur according to compressionResistance or hugging
     priorities of items, or when that is ambiguous, according to arrangement
     order.
     */
    case fill
    
    
    /* Items are all the same size.
     When space allows, this will be the size of the item with the largest
     intrinsicContentSize (along the axis of the stack).
     Overflow or underflow adjustments are distributed equally among the items.
     */
    case fillEqually
    
    
    /* Overflow or underflow adjustments are distributed among the items proportional
     to their intrinsicContentSizes.
     */
    case fillProportionally
    
    /// arrangedSubviews按照间隙相等的方式排列
    /// 每个subview的宽高, 需要通过NSLayoutConstraint来确定. 所以, 如果没有任何指定时, 会依据intrinsicContentSize来确定宽高.
    case equalSpacing
    
    
    /* Equal center-to-center spacing of the items is maintained as much
     as possible while still maintaining a minimum edge-to-edge spacing within the
     allowed area.
     Additional underflow spacing is divided equally in the spacing. Overflow
     squeezing is distributed first according to compressionResistance priorities
     of items, then according to subview order while maintaining the configured
     (edge-to-edge) spacing as a minimum.
     */
    case equalCentering
}

/// stackView是一个容器, 它的arrangedSubviews会按照水平/垂直的一条直线排列.
class UIStackView {
    
    public init(frame: CGRect)
    
    public init(coder: NSCoder)

    /// 这是一个convenience, 它不能被overridden
    /// views会添加到arrangedSubviews, 同时也会成为stackView的子视图
    /// 当view从arrangedSubviews中移除时, 同时也会从stackView的子视图中移除
    public convenience init(arrangedSubviews views: [UIView])
    
    /// 排列在stackView中的子视图
    open var arrangedSubviews: [UIView] { get }
    
    /// 将view加入到arrangedSubviews的末尾. 如果这个view已经存在, 则相当于什么都没发生
    open func addArrangedSubview(_ view: UIView)
    
    /// 从arrangedSubviews中, 移去view.
    /// 被移去的view会自动调用-removeFromSuperview方法, 将自己从stackView中移去; 也会从arrangedSubviews中, 将自己移去
    open func removeArrangedSubview(_ view: UIView)
    
    /// 在arrangedSubviews中间插入一个子视图
    open func insertArrangedSubview(_ view: UIView, at stackIndex: Int)
    
    /// 子视图的排列方向
    /// - horizontal: 子视图从左往右排列
    /// - vertical: 子视图从上往下排列
    open var axis: UILayoutConstraintAxis
    
    /// 这个属性非常重要, 它定义了arrangedSubviews如何在stackView中排列
    /// 不同的distribution, 会影响到arrangedSubviews的尺寸与位置
    /// 具体信息, 参考UIStackViewDistribution
    open var distribution: UIStackViewDistribution
    
    /// 当arrangedSubviews沿着axis排列时, 如果distribution不是fill, 那么他们的width/height会不同.
    /// 在这种情况下, alignment描述了它们的对齐方式
    open var alignment: UIStackViewAlignment
    
    /// 描述了arrangedSubviews之间的间隙. 针对不同的distribution, 有不同的表达含义, 这个值为负数时, 子视图甚至可以重叠.
    /// - 当distribution是各种Fill类型时, spacing就是间隙的具体值
    /// - 当distribution是EqualCentering或EqualSpacing时, spacing是间隙的最小值
    /// 如果axis == vertical, 并且baselineRelativeArrangement == YES, 文本内容的视图(例如UILabel)之间的spacing, 受到字体影响
    open var spacing: CGFloat
    
    
    /* Set and get custom spacing after a view.
     
     This custom spacing takes precedence over any other value that might otherwise be used
     for the space following the arranged subview.
     
     Defaults to UIStackViewSpacingUseDefault (Swift: UIStackView.spacingUseDefault), where
     resolved value will match the spacing property.
     
     You may also set the custom spacing to UIStackViewSpacingUseSystem (Swift: UIStackView.spacingUseSystem),
     where the resolved value will match the system-defined value for the space to the neighboring view,
     independent of the spacing property.
     
     Maintained when the arranged subview changes position in the stack view, but not after it
     is removed from the arrangedSubviews list.
     
     Ignored if arrangedSubview is not actually an arranged subview.
     */
    @available(iOS 11.0, *)
    open func setCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView)
    
    @available(iOS 11.0, *)
    open func customSpacing(after arrangedSubview: UIView) -> CGFloat
    
    
    /* Baseline-to-baseline spacing in vertical stacks.
     The baselineRelativeArrangement property supports specifications of vertical
     space from the last baseline of one text-based view to the first baseline of a
     text-based view below, or from the  top (or bottom) of a container to the first
     (or last) baseline of a contained text-based view.
     This property is ignored in horizontal stacks. Use the alignment property
     to specify baseline alignment in horizontal stacks.
     Defaults to NO.
     */
    open var isBaselineRelativeArrangement: Bool
    
    
    /* Uses margin layout attributes for edge constraints where applicable.
     Defaults to NO.
     */
    open var isLayoutMarginsRelativeArrangement: Bool
}
