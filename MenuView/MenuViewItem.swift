//
//  MenuViewItem.swift
//  MenuView
//
//  Created by 雷广 on 2018/6/22.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

/// MenuView中默认的单个Item （纯文字）
public final class MenuViewItem: UIView, MenuViewItemProtocol {

    // MARK: - 视图参数配置
    public class Config {
        
        /// 正常的文字颜色
        var normalTextColor: UIColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 1)
        /// 被选中的文字颜色
        var selectedTextColor: UIColor = UIColor(red: 0, green: 181.0/255.0, blue: 1, alpha: 1)
        /// 正常的文字大小（默认为15.0）
        var normalTextFont: UIFont = UIFont.systemFont(ofSize: 15)
        /// 被选中的文字大小（默认为16.0）
        var selectedTextFont = UIFont.systemFont(ofSize: 16)
        
        /// 正常的背景色 (默认为.clear，因为发现默认为nil时，title为“Part1”时label背景设置nil竟为黑色!，而title为中文时却是正常的，不可思议）
        var normalBackgroundColor: UIColor? = .clear
        /// 被选中的背景色（默认为.clear，因为发现默认为nil时，title为“Part1”时label背景设置nil竟为黑色!，而title为中文时却是正常的，不可思议）
        var selectedBackgroundColor: UIColor? = .clear
        /// 正常的边框宽度 (默认为0.0)
        var normalBorderWidth: CGFloat = 0.0
        /// 被选中的边框宽度 (默认为0.0)
        var selectedBorderWidth: CGFloat = 0.0
        /// 正常的边框颜色（默认为nil）
        var normalBorderColor: UIColor? = nil
        /// 被选中的边框颜色（默认为nil）
        var selectedBorderColor: UIColor? = nil
        /// 是否需要圆角 (默认无圆角)
        var needCorner: Bool = false
        
        /// 文字到左右边框间距（默认为15.0）
        var textHorizontalSpacing: CGFloat = 15.0
        /// 文字到上下边框间距（默认为7.0）
        var textVerticalSpacing: CGFloat = 7.0
    }
    
    public var index: Int = 0
    
    /// item的size  (根据给出的文字、以及配置的Config参数，如：item宽度 = 文字宽度 + 文字到item左右边框间距)
    public var size: CGSize {
        let attrs: [NSAttributedStringKey: Any] = [.font: config.normalTextFont]
        let textSize = (text as NSString).size(withAttributes: attrs)
        let buttonWidth = textSize.width + 2 * config.textHorizontalSpacing
        let buttonHeight = textSize.height + 2 * config.textVerticalSpacing
        return CGSize(width: ceil(buttonWidth), height: ceil(buttonHeight))
    }
    
    public var isSelected: Bool = false {
        didSet {
            refreshUI()
        }
    }
    
    public var tapCallback: ((Int) -> Void)? = nil

    /// 可以随时更改item的text。
    /// - Note: 更改后还需要更新MenuView中的items布局，必须手动调用menuView.setNeedsLayout()
    public var text: String {
        didSet {
            refreshUI()
        }
    }
    
    
    /// 默认配置
    private let config: Config
    private let label = UILabel()
    
    init(text: String, config: Config? = nil) {
        self.text = text
        self.config = ((config != nil) ? config! : Config())
        super.init(frame: .zero)
        
        label.frame = CGRect(origin: .zero, size: size)
        label.textAlignment = .center
        addSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGesture)
        
        refreshUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    @objc private func tap() {
        tapCallback?(index)
    }

    
    /// 刷新UI
    private func refreshUI() {
        if isSelected {
            label.textColor = config.selectedTextColor
            label.font = config.selectedTextFont
            label.backgroundColor = config.selectedBackgroundColor
            label.layer.borderWidth = config.selectedBorderWidth
            label.layer.borderColor = config.selectedBorderColor?.cgColor
        } else {
            label.textColor = config.normalTextColor
            label.font = config.normalTextFont
            label.backgroundColor = config.normalBackgroundColor
            label.layer.borderWidth = config.normalBorderWidth
            label.layer.borderColor = config.normalBorderColor?.cgColor
        }
        label.layer.cornerRadius = config.needCorner ? size.height / 2 : 0
        label.layer.masksToBounds = config.needCorner
        label.text = text
        label.frame.size = size
        frame.size = size
    }
}

// MARK: - 快速创建一组默认的MenuViewItem
extension MenuViewItem {
    
    /// 用text数组 快速创建一组MenuViewItem
    static func createItems(_ texts: [String], config: ((Config)->Void)? = nil) -> [MenuViewItem] {
        let defaultConfig = Config()
        config?(defaultConfig)
        
        var items: [MenuViewItem] = []
        for text in texts {
            let item = MenuViewItem(text: text, config: defaultConfig)
            items.append(item)
        }
        return items
    }
}

