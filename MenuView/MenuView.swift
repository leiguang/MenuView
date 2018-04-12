//
//  MenuView.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit


class MenuView: UIScrollView {

    struct Config {
        var textColor: UIColor = .lightGray         // 文字默认颜色
        var selectedTextColor: UIColor = .blue      // 被选中的文字颜色
        var textFont: UIFont = UIFont.systemFont(ofSize: 17)
        
        var buttonBackgroundColor: UIColor? = nil   // 按钮默认没有背景色
        var buttonSpacing: CGFloat = 20             // 按钮间距
        var innerHorizontalSpacing: CGFloat = 10    // 按钮内部文字到button左右边框间距
        var innerVerticalSpacing: CGFloat = 5       // 按钮内部文字到button上下边框间距
        var leadingSpacing: CGFloat = 30            // 第一个button到视图(MenuView)头部的间距
        var trailingSpacing: CGFloat = 30           // 最后一个button到视图(MenuView)尾部的间距
        
        var indicatorWidth: CGFloat = 35            // 指示器宽度
        var indicatorHeight: CGFloat = 3            // 指示器高度
        var indicatorColor: UIColor = .blue         // 指示器颜色
    }
    
    // 供外部修改配置
    var config: Config = Config()
    
    var texts: [String] = [] {
        didSet {
            addButtons()
        }
    }
    
    // 按钮数组
    private var buttons: [UIButton] = []
    
    // 添加文本按钮
    private func addButtons() {
        // 如果buttons不为空，则先移除之前的button
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        guard texts.count > 0 else { return }
        
        // 文本属性
        let textAttrs: [NSAttributedStringKey: Any] = [
            .font: config.textFont,
            .foregroundColor: config.textColor,
        ]
        
        // button.size数组
        var buttonSizes: [CGSize] = texts.map { calculateButtonWidth($0, attrs: textAttrs) }
        // 计算全部button的总宽度
        let buttonsTotalWidth = buttonSizes.reduce(into: 0) { $0 += $1.width }
        // 计算放置全部button 所需的总宽度: (全部button宽度 + button之间的间距 + 头部间距 + 尾部间距)
        let neededTotalWidth = buttonsTotalWidth + CGFloat((texts.count - 1)) * config.buttonSpacing + config.leadingSpacing + config.trailingSpacing
        
        
        // 当个数较少时，由于要居中显示，得计算第一个button的 "origin.x"，默认值为"config.leadingSpacing"
        var originX: CGFloat = config.leadingSpacing
        
        // 如果所需宽度大于自身宽度，可以左右滚动，否不能滚动
        if neededTotalWidth > self.bounds.width {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
            originX = (self.bounds.width - neededTotalWidth) / 2
        }
        self.showsHorizontalScrollIndicator = false
        self.contentSize = CGSize(width: neededTotalWidth, height: 0)
        
        
        for (index, text) in texts.enumerated() {
            // 创建单个button
            let size = buttonSizes[index]
            let x = originX + (size.width + config.innerHorizontalSpacing) * CGFloat(index)
            let y = (self.bounds.height - size.height) / 2
            let button = UIButton(type: .system)
            button.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
            button.backgroundColor = config.buttonBackgroundColor
            button.setAttributedTitle(NSAttributedString(string: text, attributes: textAttrs), for: .normal)
            self.addSubview(button)
        }
        
    }

    // 计算按钮宽高 (根据给出的文字、以及配置的Config参数)
    private func calculateButtonWidth(_ text: String, attrs: [NSAttributedStringKey: Any]) -> CGSize {
        let textSize = (text as NSString).size(withAttributes: attrs)
        let buttonWidth = textSize.width + 2 * config.innerHorizontalSpacing
        let buttonHeight = textSize.height + 2 * config.innerVerticalSpacing
        return CGSize(width: buttonWidth, height: buttonHeight)
    }
    
}


