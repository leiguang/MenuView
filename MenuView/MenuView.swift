//
//  MenuView.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

/// 多个标题栏视图
public class MenuView: UIScrollView {
    
    /// 视图参数配置
    public class Config {
        /// 标题默认颜色
        var textColor: UIColor = .lightGray
        /// 被选中的文字颜色
        var textSelectedColor: UIColor = .black
        /// 文字大小
        var textFont: UIFont = UIFont.systemFont(ofSize: 17)
        /// 被选中的文字大小
        var textSelectedFont = UIFont.systemFont(ofSize: 18)
        
        /// 按钮默认没有背景色
        var buttonBackgroundColor: UIColor? = nil
        /// 按钮被选中的背景色
        var buttonSelectedBackgroundColor: UIColor? = nil
        /// 按钮左右间距
        var buttonVerticalSpacing: CGFloat = 25
        /// 按钮内部文字到button左右边框间距
        var innerHorizontalSpacing: CGFloat = 10
        /// 按钮内部文字到button上下边框间距
        var innerVerticalSpacing: CGFloat = 8
        /// 第一个button到视图(MenuView)头部的间距
        var leadingSpacing: CGFloat = 20
        /// 最后一个button到视图(MenuView)尾部的间距
        var trailingSpacing: CGFloat = 20
        
        /// 指示器宽度
        var indicatorWidth: CGFloat = 35
        /// 指示器高度
        var indicatorHeight: CGFloat = 3
        /// 指示器颜色
        var indicatorColor: UIColor = .blue
    }
    
    
    /// 被选中的button的index
    private(set) var selectedIndex: Int = 0
    
    /// 按钮被点击的回调（只要按钮被点击就回走这个回调）
    public var selectedCallback: ((Int)->Void)?
    /// 按钮已被选中，再次被重复点击时才会回调
    public var selectedRepeatedCallback: ((Int)->Void)?
    /// 切换了选中按钮时才会回调
    public var selectedIndexChangedCallback: ((Int)->Void)?
    
    
    /// 设置标题，配置视图参数
    public func setTexts(_ texts: [String], config: ((Config)->Void)? = nil) {
        self.texts = texts
        config?(self.config)
        addButtons()
    }
    
    /// 选中位于index的button
    public func selectButtonAt(_ index: Int) {
        for (i, button) in self.buttons.enumerated() {
            let text = self.texts[i]
            if index == i {
                button.backgroundColor = config.buttonSelectedBackgroundColor
                button.setAttributedTitle(NSAttributedString(string: text, attributes: textSelectedAttrs), for: .normal)
            } else {
                button.backgroundColor = config.buttonBackgroundColor
                button.setAttributedTitle(NSAttributedString(string: text, attributes: textAttrs), for: .normal)
            }
        }
        
        // 初始化按钮时不必回调
        guard self.hasInitializedButtons == true else { return }
        
        if self.selectedIndex == index {
            self.selectedIndex = index
            self.selectedRepeatedCallback?(index)
        } else {
            self.selectedIndex = index
            self.selectedIndexChangedCallback?(index)
        }
        selectedCallback?(index)
    }
    
    
    
    /// 默认配置
    private var config: Config = Config()
    /// 文本数组
    private var texts: [String] = []
    /// 按钮数组
    private var buttons: [UIButton] = []
    /// 为防止和其他view的tag值冲突，定义一个较大的按钮基础tag值，每个按钮的 tag = buttonBaseTag + index
    private let buttonBaseTag: Int = 1000
    /// 按钮的状态是否已经初始化过
    private var hasInitializedButtons: Bool = false
    
    
    /// 添加文本按钮，配置视图
    private func addButtons() {
        // 如果buttons不为空，需要移除之前的button
        self.buttons.forEach { $0.removeFromSuperview() }
        self.buttons.removeAll()
        self.hasInitializedButtons = false
        
        guard self.texts.count > 0 else { return }

        
        
        // button.size数组
        let buttonSizes: [CGSize] = self.texts.map(calculateButtonWidth)
        // 计算全部button的总宽度
        let buttonsTotalWidth = buttonSizes.reduce(into: 0) { $0 += $1.width }
        // 计算放置全部button 所需的总宽度: (全部button宽度 + button之间的间距 + 头部间距 + 尾部间距)
        let neededTotalWidth = buttonsTotalWidth + CGFloat((self.texts.count - 1)) * config.buttonVerticalSpacing + config.leadingSpacing + config.trailingSpacing
        
        
        // 当个数较少时，由于要居中显示，得计算第一个button的 "origin.x"，默认值为"config.leadingSpacing"
        var originX: CGFloat = config.leadingSpacing
        
        // 如果所需宽度大于自身宽度，可以左右滚动，否不能滚动
        if neededTotalWidth > self.bounds.width {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
            originX = (self.bounds.width - buttonsTotalWidth) / 2
        }
        self.showsHorizontalScrollIndicator = false
        self.contentSize = CGSize(width: neededTotalWidth, height: 0)
        
        
        for index in 0..<self.texts.count {
            // 创建单个button
            let size = buttonSizes[index]
            let y = (self.bounds.height - size.height) / 2
            let button = UIButton(frame: CGRect(origin: CGPoint(x: originX, y: y), size: size))
            button.tag = self.buttonBaseTag + index
            button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            self.addSubview(button)
            self.buttons.append(button)
            
            originX = originX + (size.width + config.buttonVerticalSpacing)
        }
        
        selectButtonAt(0)
        self.hasInitializedButtons = true
    }
    
    
    /// 点击某个button
    @objc private func tapButton(_ button: UIButton) {
        let index = button.tag - buttonBaseTag
        selectButtonAt(index)
    }

    /// 计算按钮宽高 (根据给出的文字、以及配置的Config参数，如：button宽度 = 文字宽度 + 按钮内部文字到button左右边框间距)
    private func calculateButtonWidth(_ text: String) -> CGSize {
        let textSize = (text as NSString).size(withAttributes: self.textAttrs)
        let buttonWidth = textSize.width + 2 * config.innerHorizontalSpacing
        let buttonHeight = textSize.height + 2 * config.innerVerticalSpacing
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
    
}


