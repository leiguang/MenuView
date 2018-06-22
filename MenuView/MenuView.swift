//
//  MenuView.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

/// 自定义MenuViewItem所需要遵守的协议
public protocol MenuViewItemProtocol {
    
    /// item的index (用来知道点击的是第几个item。 Item中只需要声明并赋值为0就好了，当items数组加入到MenuView时，MenuView中会给它赋值的)
    var index: Int { get set }
    
    /// item的size
    var size: CGSize { get }
    
    /// 设置选中状态 (应在didSet方法中设置其“选中/未选中”状态)
    var isSelected: Bool { get set }
    
    /// item的点击回调 (Int: index)
    var tapCallback: ((Int)->Void)? { get set }
}


/**
 多个标题栏视图。（如“推荐”、“热点”、“视频”）
 1. 当视图的宽度比内容宽度小时，自动可以左右滚动；反之不能滑动，且item在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）。
 2. 使用"func setItems(_ items:, config:)"添加items。
 3. 提供了三个点击的回调事件"selectedCallback"、“selectedRepeatedCallback”、“selectedIndexChangedCallback”，以及一个主动选中的方法”selectedIndex(at: )“
 - Note: 为解决有些情况下scrollView内容向下偏移的问题，将scrollView用UIView封装一层，因为只有作为viewController的第一个视图的时候才会发生偏移。
 */
public class MenuView: UIView {
    
    // MARK: - 视图参数配置
    public class Config {
        
        /// MenuView背景颜色（默认没有）
        var backgroundColor: UIColor? = nil
        
        /// 第一个item的左间距（默认为0.0）
        var leadingSpacing: CGFloat = 0.0
        /// 最后一个item的右间距（默认为0.0）
        var trailingSpacing: CGFloat = 0.0
        /// item左右间距（默认为10.0）
        var itemSpacing: CGFloat = 10.0
        
        /// 是否显示滚动指示器
        var isShowIndicator: Bool = true
        /// 指示器宽度相对于item宽度的比例 (默认：1/3)
        var indicatorWidthRatio: CGFloat = 1/3
        /// 指示器高度（默认为3.0）
        var indicatorHeight: CGFloat = 3.0
        /// 指示器颜色
        var indicatorColor: UIColor = UIColor(red: 0, green: 181.0/255.0, blue: 1, alpha: 1)
        
        /// 小红点半径（默认为4.0）
        var reddotRadius: CGFloat = 4.0
    }
    
   
    public typealias Item = MenuViewItemProtocol & UIView
    
    /// items数组
    public var items: [Item] = []
    
    /// item被点击的回调（只要item被点击就回走这个回调）
    public var selectedCallback: ((Int)->Void)?
    
    /// item已被选中，再次被重复点击时才会回调
    public var selectedRepeatedCallback: ((Int)->Void)?
    
    /// 切换了选中item时才会回调
    public var selectedIndexChangedCallback: ((Int)->Void)?
    
    /// 获取当前被选中的item的index
    private(set) var selectedIndex: Int = 0
    
    /**
     将scrollView暴露出来，在外面可能会用到。
     例如项目中首页侧边栏解决手势冲突: Solve the conflict between sideMenuGesture and scrollView.panGesture。Create a dependency relationship between scrollView.panGestureRecognizer and presentGesture.
     self.menuView.scrollView.panGestureRecognizer.require(toFail: self.sideMenuTransitioning.interactiveTransition.presentGesture)
     */
    public let scrollView = UIScrollView()
    
    /// 当前选择的item的指示器
    private lazy var indicator = UIView()
    
    /// 默认配置
    private var config: Config = Config()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(scrollView)
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    
    // MARK: - Public Interface
    
    /// 设置标题，配置视图参数（MenuView.Config: 颜色、间距、字体大小...）
    /// 调用此方法会自动移除旧的items 并重新设置、布局
    public func setItems(_ items: [Item], config: ((Config)->Void)? = nil) {
        guard items.count > 0 else { return }
        
        clear()
        self.items = items
        config?(self.config)
        addItems()
    }
    
    /// 选中位于index的item
    public func selectItemAt(_ index: Int) {
        guard index < self.items.endIndex else { return }
        
        setItemSelectedStateAt(index)
        
        if self.selectedIndex == index {
            self.selectedIndex = index
            self.selectedRepeatedCallback?(index)
        } else {
            self.selectedIndex = index
            self.selectedIndexChangedCallback?(index)
        }
        selectedCallback?(index)
    }
    
    /// 更新下划线indicator的偏移进度百分比
    public func updateIndicator(progress: CGFloat) {
        guard self.items.count > 0, progress >= 0, progress <= 1 else { return }
        
        if config.isShowIndicator {
            
            // 由于要适配字体宽度，因此不同item宽度不同，不能简单的使用等比距离的偏移量来计算item/indicator的偏移量。
            // 先找出当前的progress是在哪两个items之间
            
            // 传入的参数progress是按总偏移量的等比计算的
            // 每切换一个item的进度是
            let averageProgress: CGFloat = 1 / CGFloat(self.items.count - 1)
            // 计算偏移的个数
            let offsetCount: CGFloat = progress / averageProgress
            
            // 左边的item
            let leftIndex: Int = Int(floor(offsetCount))
            let leftItem = self.items[leftIndex]
            // 右边的item
            let rightIndex: Int = Int(ceil(offsetCount))
            let rightItem = self.items[rightIndex]
            
            // 计算两个item之间的进度
            let segmentProgress = progress.truncatingRemainder(dividingBy: averageProgress) / averageProgress
            
            let leftIndicatorWidth = leftItem.bounds.width * config.indicatorWidthRatio
            let rightIndicatorWidth = rightItem.bounds.width * config.indicatorWidthRatio
            
            let leftIndicatorCenterX = leftItem.center.x
            let rightIndicatorCenterX = rightItem.center.x
            
            // indicator 的实际大小位置
            let width = ceil(leftIndicatorWidth + (rightIndicatorWidth - leftIndicatorWidth) * segmentProgress)
            let height = config.indicatorHeight
            let centerX = leftIndicatorCenterX + (rightIndicatorCenterX - leftIndicatorCenterX) * segmentProgress
            let centerY = self.bounds.height - height / 2 - 1
            
            self.indicator.bounds = CGRect(x: 0, y: 0, width: width, height: height)
            self.indicator.center = CGPoint(x: centerX, y: centerY)
        }
    }
    
    
    // MARK: - Private Implementions
    
    
    /// 清除items数据， 移除items、indicator、小红点视图
    private func clear() {
        for (index, item) in items.enumerated() {
            item.removeFromSuperview()
            removeReddot(at: index)
        }
        items.removeAll()
        indicator.removeFromSuperview()
    }
    
    /// 添加items，默认选中第1个
    private func addItems() {
        guard items.count > 0 else { return }
 
        // 添加item
        for i in 0..<items.count {
            items[i].index = i
            items[i].tapCallback = { [weak self] (index) in
                self?.selectItemAt(index)
            }
            scrollView.addSubview(items[i])
        }
        
        // 添加下划线指示器
        if config.isShowIndicator {
            indicator.backgroundColor = config.indicatorColor
            indicator.layer.cornerRadius = config.indicatorHeight / 2
            indicator.clipsToBounds = true
            scrollView.addSubview(indicator)
        }
        
        setItemSelectedStateAt(0)
        setNeedsLayout()
    }
    
    
    /// - 1.设置item的选中状态，并遍历设置其他item为非选中状态
    /// - 2.如果视图可滚动，还需要设置被选中的item尽量偏移到视图正中间
    /// - 3.如果显示滚动指示器，则设置其大小位置
    private func setItemSelectedStateAt(_ index: Int) {
        guard index < items.endIndex else { return }
        
        // 1.设置item的选中状态，并遍历设置其他item为非选中状态
        for i in 0..<items.count {
            if i == index { // 被选中
                items[i].isSelected = true
            } else {        // 未选中
                items[i].isSelected = false
            }
        }
        
        // 2.如果视图可滚动，还需要设置被选中的item尽量偏移到视图正中间
        if scrollView.isScrollEnabled {
            let item = items[index]
            // 计算被选中item的中心点 到scrollView中心点的偏移量
            var offsetX = item.center.x - center.x
            // 计算scrollView能滑动的最大偏移量
            let maxOffsetX = scrollView.contentSize.width - bounds.width
            if offsetX < 0 {    // 已经在中心点左边了，不需要再偏移
                offsetX = 0
            } else if offsetX > maxOffsetX {    // 需要的偏移量超出了最大偏移量，设置为最大偏移
                offsetX = maxOffsetX
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
        // 3.如果显示滚动指示器，则设置其大小位置
        if config.isShowIndicator {
            let item = items[index]
            let indicatorWidth = ceil(item.bounds.width * config.indicatorWidthRatio)
            let indicatorHeight = config.indicatorHeight
            UIView.animate(withDuration: 0.25) {
                self.indicator.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
                self.indicator.center = CGPoint(x: item.center.x, y: self.bounds.height - indicatorHeight / 2 - 1)
            }
        }
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard items.count > 0 else { return }
       
        // 计算全部item的总宽度
        let itemsTotalWidth = items.map { $0.size }.reduce(into: 0) { $0 += $1.width }
        // 计算放置全部item 所需的总宽度: (全部item宽度 + item之间的间距 + 头部间距 + 尾部间距)
        let neededTotalWidth = itemsTotalWidth + CGFloat((items.count - 1)) * config.itemSpacing + config.leadingSpacing + config.trailingSpacing
        
        
        // 如果所需宽度大于自身宽度，可以左右滚动，否不能滚动
        if neededTotalWidth > bounds.width {
            scrollView.isScrollEnabled = true
        } else {
            scrollView.isScrollEnabled = false
        }
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: neededTotalWidth, height: 0)
        scrollView.backgroundColor = config.backgroundColor
        scrollView.showsHorizontalScrollIndicator = false
        
        
        // 每个item对应的x，当个数较少时，由于要居中显示，得计算第一个item的 "origin.x"，默认值为"config.leadingSpacing"
        var originX = config.leadingSpacing
        
        for (index, item) in items.enumerated() {
            let size = items[index].size
            let y = (bounds.height - size.height) / 2
            var frame: CGRect = .zero
            
            if scrollView.isScrollEnabled == true {    // 可以滚动
                frame = CGRect(origin: CGPoint(x: originX, y: y), size: size)
                originX += (size.width + config.itemSpacing)
            } else {    // 不能滚动，则需要把item在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）
                let sectionWidth = (bounds.width - config.leadingSpacing - config.trailingSpacing) / CGFloat(items.count)   // 分成的每部分宽度
                let x = originX + (sectionWidth - size.width) / 2
                frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
                originX += sectionWidth
            }
            
            item.frame = frame
        }
        
        // 如果显示滚动指示器，则设置其大小位置
        if config.isShowIndicator {
            let item = items[selectedIndex]
            let indicatorWidth = ceil((item.bounds.width) * config.indicatorWidthRatio)
            let indicatorHeight = config.indicatorHeight
            indicator.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
            indicator.center = CGPoint(x: item.center.x, y: bounds.height - indicatorHeight / 2 - 1)
        }
    }
    
    
    // MARK: - 小红点
    
    /// 为防止和其他view的tag值冲突，定义一个较大的红点的基础tag值，每个小红点的 tag = reddotBaseTag + index
    private let reddotBaseTag: Int = 2000
    
    ///添加红点
    public func addReddot(at index: Int) {
        guard index < self.items.endIndex else { return }
        
        // 确保该index不存在小红点，如果有，则不再重复添加
        guard self.viewWithTag(self.reddotBaseTag + index) == nil else { return }
        
        // 由于一般不要在UIControl控件上添加view（有可能会发生奇怪的错误），所以还是将红点添加到MenuView上
        let radius = config.reddotRadius
        let itemFrame = self.items[index].frame
        let reddotFrame = CGRect(x: itemFrame.maxX - radius * 1.5, y: itemFrame.minY + radius * 0.5, width: radius * 2, height: radius * 2)
        
        let reddot = UIView(frame: reddotFrame)
        reddot.backgroundColor = UIColor.red
        reddot.tag = self.reddotBaseTag + index
        reddot.layer.cornerRadius = radius
        self.scrollView.addSubview(reddot)
    }
    
    ///移除红点
    public func removeReddot(at index: Int) {
        guard index < self.items.endIndex else { return }
        guard let reddot = self.viewWithTag(self.reddotBaseTag + index) else { return }
        reddot.removeFromSuperview()
    }
}


