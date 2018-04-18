//
//  MenuView.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

/// 多个标题栏视图。
/// 使用时只需要"setTexts(...)"设置标题，当视图的宽度比内容宽度小时，自动可以左右滚动；反之不能滑动。
/// 提供了三个点击的回调事件"selectedCallback"、“selectedRepeatedCallback”、“selectedIndexChangedCallback”，以及一个主动选中的方法”selectedIndex(at: )“
/// - Note: 没有对AutoLayout做适配，用代码创建的话请使用先设置menuView.frame，再用“setTexts(..)”赋值
public class MenuView: UIScrollView {
    
    // MARK: - 视图参数配置（颜色、间距、字体大小...）
    /// 视图参数配置颜色、间距、字体大小...
    public class Config {
        /// MenuView背景颜色(默认没有)
        var backgroundColor: UIColor? = nil
        
        /// 标题默认颜色
        var textColor: UIColor = .lightGray
        /// 被选中的文字颜色
        var textSelectedColor: UIColor = .green
        /// 文字大小
        var textFont: UIFont = UIFont.systemFont(ofSize: 16)
        /// 被选中的文字大小
        var textSelectedFont = UIFont.systemFont(ofSize: 17)
        
        /// 按钮背景色(默认没有)
        var buttonBackgroundColor: UIColor? = nil
        /// 按钮边框颜色(默认没有)
        var buttonBorderColor: UIColor? = nil
        /// 按钮被选中的边框颜色(默认没有)
        var buttonSelectedBorderColor: UIColor? = nil
        /// 按钮边框宽度(默认为0没有)
        var buttonBorderWidth: CGFloat = 0
        /// 按钮被选中的边框宽度（默认为0没有）
        var buttonSelectedBorderWidth: CGFloat = 0
        /// 按钮是否需要圆角(默认不需要)
        var buttonCorner: Bool = false
        /// 按钮被选中的背景色
        var buttonSelectedBackgroundColor: UIColor? = nil
        
        /// 第一个button到视图(MenuView)头部的间距
        var leadingSpacing: CGFloat = 20
        /// 最后一个button到视图(MenuView)尾部的间距
        var trailingSpacing: CGFloat = 20
        /// 按钮左右间距
        var buttonHorizontalSpacing: CGFloat = 20
        /// 按钮内部文字到button左右边框间距
        var buttonInnerTextHorizontalSpacing: CGFloat = 15
        /// 按钮内部文字到button上下边框间距
        var buttonInnerTextVerticalSpacing: CGFloat = 6
        
        /// 是否显示滚动指示器
        var isShowIndicator: Bool = true
        /// 指示器宽度相对于文字宽度的比例 (默认：1/3)
        var indicatorWidthRatio: CGFloat = 1/3
        /// 指示器高度
        var indicatorHeight: CGFloat = 3
        /// 指示器颜色
        var indicatorColor: UIColor = .green
        
        /// 小红点半径（默认是4）
        var reddotRadius: CGFloat = 4
    }
    
    
    
    // MARK: - Public Interface
    
    /// 设置标题，配置视图参数（MenuView.Config: 颜色、间距、字体大小...）
    public func setTexts(_ texts: [String], config: ((Config)->Void)? = nil) {
        self.texts = texts
        config?(self.config)
        addButtons()
    }
    
    /// 选中位于index的button
    public func selectButtonAt(_ index: Int) {
        guard index <= self.buttons.count - 1 else { return }
        
        self.setButtonSelectedState(at: index)
        
        if self.selectedIndex == index {
            self.selectedIndex = index
            self.selectedRepeatedCallback?(index)
        } else {
            self.selectedIndex = index
            self.selectedIndexChangedCallback?(index)
        }
        selectedCallback?(index)
    }
    
    /// 获取当前被选中的button的index
    private(set) var selectedIndex: Int = 0
    /// 按钮被点击的回调（只要按钮被点击就回走这个回调）
    public var selectedCallback: ((Int)->Void)?
    /// 按钮已被选中，再次被重复点击时才会回调
    public var selectedRepeatedCallback: ((Int)->Void)?
    /// 切换了选中按钮时才会回调
    public var selectedIndexChangedCallback: ((Int)->Void)?
    
    // MARK: - 添加红点
    public func addReddot(at index: Int) {
        guard index <= self.buttons.count - 1 else { return }
        
        // 确保该index不存在小红点，如果有，则不再重复添加
        guard self.viewWithTag(self.reddotBaseTag + index) == nil else { return }
        
        // 由于一般不要在UIControl控件上添加view（有可能会发生奇怪的错误），所以还是将红点添加到MenuView上
        let radius = config.reddotRadius
        let buttonFrame = self.buttons[index].frame
        let reddotFrame = CGRect(x: buttonFrame.maxX - radius * 1.5, y: buttonFrame.minY + radius * 0.5, width: radius * 2, height: radius * 2)
        
        let reddot = UIView(frame: reddotFrame)
        reddot.backgroundColor = UIColor.red
        reddot.tag = self.reddotBaseTag + index
        reddot.layer.cornerRadius = radius
        self.addSubview(reddot)
    }
    
    // MARK: - 移除红点
    public func removeReddot(at index: Int) {
        guard index <= self.buttons.count - 1 else { return }
        guard let reddot = self.viewWithTag(self.reddotBaseTag + index) else { return }
        reddot.removeFromSuperview()
    }
    
    
    // MARK: - Private Implementions
    
    /// 默认配置
    private var config: Config = Config()
    /// 文本数组
    private var texts: [String] = []
    /// 按钮数组
    private var buttons: [UIButton] = []
    /// 为防止和其他view的tag值冲突，定义一个较大的按钮的基础tag值，每个按钮的 tag = buttonBaseTag + index
    private let buttonBaseTag: Int = 1000
    /// 为防止和其他view的tag值冲突，定义一个较大的红点的基础tag值，每个小红点的 tag = reddotBaseTag + index
    private let reddotBaseTag: Int = 2000
    /// 按钮的指示器
    private lazy var indicator = CALayer()
 
    
    /// 添加文本按钮，配置视图
    private func addButtons() {
        // MenuView需要先手动设置MenuView的frame
        guard self.frame != CGRect.zero else {
            fatalError("MenuView: 需要先设置MenuView的frame")
        }
        
        // 如果buttons不为空，需要移除之前的button
        self.buttons.forEach { $0.removeFromSuperview() }
        self.buttons.removeAll()
        
        guard self.texts.count > 0 else { return }

        
        // button.size数组
        let buttonSizes: [CGSize] = self.texts.map(calculateButtonWidth)
        // 计算全部button的总宽度
        let buttonsTotalWidth = buttonSizes.reduce(into: 0) { $0 += $1.width }
        // 计算放置全部button 所需的总宽度: (全部button宽度 + button之间的间距 + 头部间距 + 尾部间距)
        let neededTotalWidth = buttonsTotalWidth + CGFloat((self.texts.count - 1)) * config.buttonHorizontalSpacing + config.leadingSpacing + config.trailingSpacing
        
        
        // 当个数较少时，由于要居中显示，得计算第一个button的 "origin.x"，默认值为"config.leadingSpacing"
        var originX: CGFloat = config.leadingSpacing
        
        // 如果所需宽度大于自身宽度，可以左右滚动，否不能滚动
        // 如果不能滚动，则需要把按钮在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）
        if neededTotalWidth > self.bounds.width {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
            originX = (self.bounds.width - buttonsTotalWidth) / 2
        }
        self.contentSize = CGSize(width: neededTotalWidth, height: 0)
        self.backgroundColor = config.backgroundColor
        self.showsHorizontalScrollIndicator = false
        
        
        for index in 0..<self.texts.count {
            // 创建单个button
            let size = buttonSizes[index]
            let y = (self.bounds.height - size.height) / 2
            var x = originX
            
            // 如果不能滚动，则需要把按钮在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）
            if self.isScrollEnabled == false {
                // 计算分成的每部分宽度
                let sectionWidth = self.bounds.width / CGFloat(self.texts.count)
                x = (sectionWidth - size.width) / 2 + sectionWidth * CGFloat(index)
            }
            let frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            
            let button = UIButton(frame: frame)
            button.tag = self.buttonBaseTag + index
            button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            self.addSubview(button)
            self.buttons.append(button)
            
            if self.isScrollEnabled {
                originX = originX + (size.width + config.buttonHorizontalSpacing)
            }
        }
        
        if config.isShowIndicator {
            self.indicator.backgroundColor = config.indicatorColor.cgColor
            self.indicator.cornerRadius = config.indicatorHeight / 2
            self.layer.addSublayer(self.indicator)
        }
        
        self.setButtonSelectedState(at: 0)
    }
    
    
    /// 点击某个button
    @objc private func tapButton(_ button: UIButton) {
        let index = button.tag - buttonBaseTag
        selectButtonAt(index)
    }
    
    /// - 1.设置按钮的选中状态，并遍历设置其他按钮为非选中状态
    /// - 2.如果视图可滚动，还需要设置被选中的按钮尽量偏移到视图正中间
    /// - 3.如果显示滚动指示器，则设置其大小位置
    private func setButtonSelectedState(at index: Int) {
        guard index <= self.buttons.count - 1 else { return }
        
        // 1.
        for (i, button) in self.buttons.enumerated() {
            let text = self.texts[i]
            if index == i { // 被选中
                button.backgroundColor = config.buttonSelectedBackgroundColor
                button.setAttributedTitle(NSAttributedString(string: text, attributes: textSelectedAttrs), for: .normal)
                button.layer.borderColor = config.buttonSelectedBorderColor?.cgColor
                button.layer.borderWidth = config.buttonSelectedBorderWidth
                button.layer.cornerRadius = config.buttonCorner ? button.bounds.height / 2 : 0
            } else {        // 未选中
                button.backgroundColor = config.buttonBackgroundColor
                button.setAttributedTitle(NSAttributedString(string: text, attributes: textAttrs), for: .normal)
                button.layer.borderColor = config.buttonBorderColor?.cgColor
                button.layer.borderWidth = config.buttonBorderWidth
                button.layer.cornerRadius = config.buttonCorner ? button.bounds.height / 2 : 0
            }
        }
        
        // 2.
        if self.isScrollEnabled {
            let button = self.buttons[index]
            // 计算被选中按钮的中心点 到scrollView中心点的偏移量
            var offsetX = button.center.x - self.center.x
            // 计算scrollView能滑动的最大偏移量
            let maxOffsetX = self.contentSize.width - self.bounds.width
            if offsetX < 0 {    // 已经在中心点左边了，不需要再偏移
                offsetX = 0
            } else if offsetX > maxOffsetX {    // 需要的偏移量超出了最大偏移量，设置为最大偏移
                offsetX = maxOffsetX
            }
            self.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        
        // 3.
        if config.isShowIndicator {
            let button = self.buttons[index]
            let indicatorWidth = (button.bounds.width - config.buttonInnerTextHorizontalSpacing * 2) * config.indicatorWidthRatio
            let indicatorHeight = config.indicatorHeight
            self.indicator.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
            self.indicator.position = CGPoint(x: button.center.x, y: self.bounds.height - indicatorHeight / 2)
        }
    }

    /// 计算按钮宽高 (根据给出的文字、以及配置的Config参数，如：button宽度 = 文字宽度 + 按钮内部文字到button左右边框间距)
    private func calculateButtonWidth(_ text: String) -> CGSize {
        let textSize = (text as NSString).size(withAttributes: self.textAttrs)
        let buttonWidth = textSize.width + 2 * config.buttonInnerTextHorizontalSpacing
        let buttonHeight = textSize.height + 2 * config.buttonInnerTextVerticalSpacing
        return CGSize(width: buttonWidth, height: buttonHeight)
    }
    
    /// 正常状态下的文字属性
    private var textAttrs: [NSAttributedStringKey: Any] {
        let attrs: [NSAttributedStringKey: Any] = [
            .font: config.textFont,
            .foregroundColor: config.textColor,
        ]
        return attrs
    }
    
    /// 被选中时的文字属性
    private var textSelectedAttrs: [NSAttributedStringKey: Any] {
        let attrs: [NSAttributedStringKey: Any] = [
            .font: config.textSelectedFont,
            .foregroundColor: config.textSelectedColor,
        ]
        return attrs
    }
    
    deinit {
        print("\(self) deinit")
    }
}


