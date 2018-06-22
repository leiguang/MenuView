////
////  MenuView.swift
////  MenuView
////
////  Created by 雷广 on 2018/4/12.
////  Copyright © 2018年 雷广. All rights reserved.
////
//
//import UIKit
//
///// 多个标题栏视图。（如“推荐”、“热点”、“视频”）
///// 使用"func setTexts(_ texts:, config:)"设置标题及显示配置。
///// 当视图的宽度比内容宽度小时，自动可以左右滚动；反之不能滑动，且按钮在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）。
///// 提供了三个点击的回调事件"selectedCallback"、“selectedRepeatedCallback”、“selectedIndexChangedCallback”，以及一个主动选中的方法”selectedIndex(at: )“
///// - Note: 为解决有些情况下scrollView内容向下偏移的问题，将scrollView用UIView封装一层，因为只有作为viewController的第一个视图的时候才会发生偏移。
//public class MenuView: UIView {
//
//    // MARK: - 视图参数配置（颜色、间距、字体大小...）
//    /// 视图参数配置颜色、间距、字体大小...
//    public class Config {
//        /// MenuView背景颜色(默认没有)
//        var backgroundColor: UIColor? = nil
//
//        /// 标题默认颜色
//        var textColor: UIColor = UIColor(red: 171.0/255.0, green: 171.0/255.0, blue: 171.0/255.0, alpha: 1)
//        /// 被选中的文字颜色
//        var textSelectedColor: UIColor = UIColor(red: 0, green: 181.0/255.0, blue: 1, alpha: 1)
//        /// 文字大小
//        var textFont: UIFont = UIFont.systemFont(ofSize: 15)
//        /// 被选中的文字大小
//        var textSelectedFont = UIFont.systemFont(ofSize: 16)
//
//        /// 按钮背景色(默认没有)
//        var buttonBackgroundColor: UIColor? = nil
//        /// 按钮边框颜色(默认没有)
//        var buttonBorderColor: UIColor? = nil
//        /// 按钮被选中的边框颜色(默认没有)
//        var buttonSelectedBorderColor: UIColor? = nil
//        /// 按钮边框宽度(默认为0没有)
//        var buttonBorderWidth: CGFloat = 0
//        /// 按钮被选中的边框宽度（默认为0没有）
//        var buttonSelectedBorderWidth: CGFloat = 0
//        /// 按钮是否需要圆角(默认不需要)
//        var buttonCorner: Bool = false
//        /// 按钮被选中的背景色
//        var buttonSelectedBackgroundColor: UIColor? = nil
//
//        /// 第一个button到视图(MenuView)头部的间距
//        var leadingSpacing: CGFloat = 20
//        /// 最后一个button到视图(MenuView)尾部的间距
//        var trailingSpacing: CGFloat = 20
//        /// 按钮左右间距
//        var buttonHorizontalSpacing: CGFloat = 10
//        /// 按钮内部文字到button左右边框间距
//        var buttonInnerTextHorizontalSpacing: CGFloat = 10
//        /// 按钮内部文字到button上下边框间距
//        var buttonInnerTextVerticalSpacing: CGFloat = 6
//
//        /// 是否显示滚动指示器
//        var isShowIndicator: Bool = true
//        /// 指示器宽度相对于文字宽度的比例 (默认：1/2)
//        var indicatorWidthRatio: CGFloat = 1/2
//        /// 指示器高度
//        var indicatorHeight: CGFloat = 3
//        /// 指示器颜色
//        var indicatorColor: UIColor = UIColor(red: 0, green: 181.0/255.0, blue: 1, alpha: 1)
//
//        /// 小红点半径（默认是4）
//        var reddotRadius: CGFloat = 4
//    }
//
//
//    // MARK: - Public Interface
//
//    /// 设置标题，配置视图参数（MenuView.Config: 颜色、间距、字体大小...）
//    /// 重复调用此方法会移除之前的内容并重新设置、布局
//    public func setTexts(_ texts: [String], config: ((Config)->Void)? = nil) {
//        self.texts = texts
//        config?(self.config)
//        reset()
//        setupUI()
//    }
//
//    /// 选中位于index的button
//    public func selectButtonAt(_ index: Int) {
//        guard index < self.buttons.endIndex else { return }
//
//        self.setButtonSelectedState(at: index)
//
//        if self.selectedIndex == index {
//            self.selectedIndex = index
//            self.selectedRepeatedCallback?(index)
//        } else {
//            self.selectedIndex = index
//            self.selectedIndexChangedCallback?(index)
//        }
//        selectedCallback?(index)
//    }
//
//    /// 更新下划线indicator的偏移进度百分比
//    public func updateIndicator(progress: CGFloat) {
//        guard self.buttons.count > 0, progress >= 0, progress <= 1 else { return }
//
//        if config.isShowIndicator {
//
//            // 由于要适配字体宽度，因此不同button宽度不同，不能简单的使用等比距离的偏移量来计算button/indicator的偏移量。
//            // 先找出当前的progress是在哪两个buttons之间
//
//            // 传入的参数progress是按总偏移量的等比计算的
//            // 每切换一个button的进度是
//            let averageProgress: CGFloat = 1 / CGFloat(self.buttons.count - 1)
//            // 计算偏移的个数
//            let offsetCount: CGFloat = progress / averageProgress
//
//            // 左边的button
//            let leftIndex: Int = Int(floor(offsetCount))
//            let leftButton = self.buttons[leftIndex]
//            // 右边的button
//            let rightIndex: Int = Int(ceil(offsetCount))
//            let rightButton = self.buttons[rightIndex]
//
//            // 计算两个button之间的进度
//            let segmentProgress = progress.truncatingRemainder(dividingBy: averageProgress) / averageProgress
//
//            let leftIndicatorWidth = (leftButton.bounds.width - config.buttonInnerTextHorizontalSpacing * 2) * config.indicatorWidthRatio
//            let rightIndicatorWidth = (rightButton.bounds.width - config.buttonInnerTextHorizontalSpacing * 2) * config.indicatorWidthRatio
//
//            let leftIndicatorCenterX = leftButton.center.x
//            let rightIndicatorCenterX = rightButton.center.x
//
//            // indicator 的实际大小位置
//            let width = ceil(leftIndicatorWidth + (rightIndicatorWidth - leftIndicatorWidth) * segmentProgress)
//            let height = config.indicatorHeight
//            let centerX = leftIndicatorCenterX + (rightIndicatorCenterX - leftIndicatorCenterX) * segmentProgress
//            let centerY = self.bounds.height - height / 2 - 1
//
//            self.indicator.bounds = CGRect(x: 0, y: 0, width: width, height: height)
//            self.indicator.center = CGPoint(x: centerX, y: centerY)
//            //            print("------------------------------------------------")
//            //            print("average: \(averageProgress)")
//            //            print("segment progress: \(segmentProgress)")
//            //            print("left index: \(leftIndex)")
//            //            print("right index: \(rightIndex)")
//            //            print("\n")
//            //            print("left width: \(leftIndicatorWidth)")
//            //            print("right width: \(rightIndicatorWidth)")
//            //            print("width: \(width)")
//            //            print("\n")
//            //            print("left x: \(leftIndicatorCenterX)")
//            //            print("right x: \(rightIndicatorCenterX)")
//            //            print("x: \(centerX)")
//            //            print("------------------------------------------------")
//        }
//    }
//
//    /// 默认配置
//    private var config: Config = Config()
//
//    /// 文本数组
//    private var texts: [String] = []
//
//    /// 获取当前被选中的button的index
//    private(set) var selectedIndex: Int = 0
//
//    /// 按钮被点击的回调（只要按钮被点击就回走这个回调）
//    public var selectedCallback: ((Int)->Void)?
//
//    /// 按钮已被选中，再次被重复点击时才会回调
//    public var selectedRepeatedCallback: ((Int)->Void)?
//
//    /// 切换了选中按钮时才会回调
//    public var selectedIndexChangedCallback: ((Int)->Void)?
//
//
//    // MARK: - Private Implementions
//
//    /// 按钮数组
//    private var buttons: [UIButton] = []
//    /// button.size数组
//    private var buttonSizes: [CGSize] = []
//    /// 全部button的总宽度
//    private var buttonsTotalWidth: CGFloat = 0
//    /// 计算放置全部button 所需的总宽度: (全部button宽度 + button之间的间距 + 头部间距 + 尾部间距)
//    private var neededTotalWidth: CGFloat = 0
//
//    /// 为防止和其他view的tag值冲突，定义一个较大的按钮的基础tag值，每个按钮的 tag = buttonBaseTag + index
//    private let buttonBaseTag: Int = 1000
//
//
//    /// 按钮的指示器
//    private lazy var indicator = UIView()
//
//    let scrollView: UIScrollView!
//
//    public override init(frame: CGRect) {
//        self.scrollView = UIScrollView()
//        super.init(frame: frame)
//        self.addSubview(self.scrollView)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        self.scrollView = UIScrollView()
//        super.init(coder: aDecoder)
//        self.addSubview(self.scrollView)
//        //        fatalError("init(coder:) has not been implemented")
//    }
//
//    deinit {
//        print("\(self) deinit")
//    }
//
//    /// 重置，移除之前所有的内容button、indicator、小红点， 重新添加，默认选中第一个
//    private func reset() {
//        for (index, button) in self.buttons.enumerated() {
//            button.removeFromSuperview()
//            removeReddot(at: index)
//        }
//        self.buttons.removeAll()
//
//        self.indicator.removeFromSuperview()
//    }
//
//    /// 添加文本按钮，配置视图
//    private func setupUI() {
//        guard self.texts.count > 0 else { return }
//
//        // button.size数组
//        self.buttonSizes = self.texts.map(calculateButtonWidth)
//        // 计算全部button的总宽度
//        self.buttonsTotalWidth = buttonSizes.reduce(into: 0) { $0 += $1.width }
//        // 计算放置全部button 所需的总宽度: (全部button宽度 + button之间的间距 + 头部间距 + 尾部间距)
//        self.neededTotalWidth = self.buttonsTotalWidth + CGFloat((self.texts.count - 1)) * config.buttonHorizontalSpacing + config.leadingSpacing + config.trailingSpacing
//
//
//        // 如果所需宽度大于自身宽度，可以左右滚动，否不能滚动
//        if self.neededTotalWidth > self.bounds.width {
//            self.scrollView.isScrollEnabled = true
//        } else {
//            self.scrollView.isScrollEnabled = false
//        }
//        self.scrollView.contentSize = CGSize(width: neededTotalWidth, height: 0)
//        self.scrollView.backgroundColor = config.backgroundColor
//        self.scrollView.showsHorizontalScrollIndicator = false
//
//
//        // 添加按钮
//        for index in 0..<self.texts.count {
//            let button = UIButton(type: .custom)
//            button.tag = self.buttonBaseTag + index
//            button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
//            self.scrollView.addSubview(button)
//            self.buttons.append(button)
//        }
//
//        // 添加指示器下划线
//        if config.isShowIndicator {
//            self.indicator.backgroundColor = config.indicatorColor
//            self.indicator.layer.cornerRadius = config.indicatorHeight / 2
//            self.indicator.clipsToBounds = true
//            self.scrollView.addSubview(self.indicator)
//        }
//
//        self.setButtonSelectedState(at: 0)
//
//        self.setNeedsLayout()
//    }
//
//    /// 点击某个button
//    @objc private func tapButton(_ button: UIButton) {
//        let index = button.tag - buttonBaseTag
//        selectButtonAt(index)
//    }
//
//    /// - 1.设置按钮的选中状态，并遍历设置其他按钮为非选中状态
//    /// - 2.如果视图可滚动，还需要设置被选中的按钮尽量偏移到视图正中间
//    /// - 3.如果显示滚动指示器，则设置其大小位置
//    private func setButtonSelectedState(at index: Int) {
//        guard index < self.buttons.endIndex else { return }
//
//        // 1.设置按钮的选中状态，并遍历设置其他按钮为非选中状态
//        for (i, button) in self.buttons.enumerated() {
//            let text = self.texts[i]
//            if index == i { // 被选中
//                button.backgroundColor = config.buttonSelectedBackgroundColor
//                button.setAttributedTitle(NSAttributedString(string: text, attributes: textSelectedAttrs), for: .normal)
//                button.layer.borderColor = config.buttonSelectedBorderColor?.cgColor
//                button.layer.borderWidth = config.buttonSelectedBorderWidth
//                button.layer.cornerRadius = config.buttonCorner ? button.bounds.height / 2 : 0
//            } else {        // 未选中
//                button.backgroundColor = config.buttonBackgroundColor
//                button.setAttributedTitle(NSAttributedString(string: text, attributes: textAttrs), for: .normal)
//                button.layer.borderColor = config.buttonBorderColor?.cgColor
//                button.layer.borderWidth = config.buttonBorderWidth
//                button.layer.cornerRadius = config.buttonCorner ? button.bounds.height / 2 : 0
//            }
//        }
//
//        // 2.如果视图可滚动，还需要设置被选中的按钮尽量偏移到视图正中间
//        if self.scrollView.isScrollEnabled {
//            let button = self.buttons[index]
//            // 计算被选中按钮的中心点 到scrollView中心点的偏移量
//            var offsetX = button.center.x - self.center.x
//            // 计算scrollView能滑动的最大偏移量
//            let maxOffsetX = self.scrollView.contentSize.width - self.bounds.width
//            if offsetX < 0 {    // 已经在中心点左边了，不需要再偏移
//                offsetX = 0
//            } else if offsetX > maxOffsetX {    // 需要的偏移量超出了最大偏移量，设置为最大偏移
//                offsetX = maxOffsetX
//            }
//            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
//        }
//
//        // 3.如果显示滚动指示器，则设置其大小位置
//        if config.isShowIndicator {
//            let button = self.buttons[index]
//            let indicatorWidth = ceil((button.bounds.width - config.buttonInnerTextHorizontalSpacing * 2) * config.indicatorWidthRatio)
//            let indicatorHeight = config.indicatorHeight
//            UIView.animate(withDuration: 0.25) {
//                self.indicator.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
//                self.indicator.center = CGPoint(x: button.center.x, y: self.bounds.height - indicatorHeight / 2 - 1)
//            }
//        }
//    }
//
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//        guard self.buttons.count > 0 else { return }
//
//        self.scrollView.frame = self.bounds
//
//        // 每个button对应的x，当个数较少时，由于要居中显示，得计算第一个button的 "origin.x"，默认值为"config.leadingSpacing"
//        var originX = config.leadingSpacing
//
//        for (index, button) in self.buttons.enumerated() {
//            // 创建单个button
//            let size = self.buttonSizes[index]
//            let y = (self.bounds.height - size.height) / 2
//            var frame: CGRect = .zero
//
//            if self.scrollView.isScrollEnabled == true {    // 可以滚动
//                frame = CGRect(origin: CGPoint(x: originX, y: y), size: size)
//                originX += (size.width + config.buttonHorizontalSpacing)
//            } else {    // 不能滚动，则需要把按钮在视图中分散居中对齐（如：view1中包含2个视图view2和view3，则先把view1分成两部分，再把view2、view3在各部分内居中）
//                let sectionWidth = (self.bounds.width - config.leadingSpacing - config.trailingSpacing) / CGFloat(self.buttons.count)   // 分成的每部分宽度
//                let x = originX + (sectionWidth - size.width) / 2
//                frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
//                originX += sectionWidth
//            }
//
//            button.frame = frame
//        }
//
//        // 如果显示滚动指示器，则设置其大小位置
//        if config.isShowIndicator {
//            let button = self.buttons[self.selectedIndex]
//            let indicatorWidth = ceil((button.bounds.width - config.buttonInnerTextHorizontalSpacing * 2) * config.indicatorWidthRatio)
//            let indicatorHeight = config.indicatorHeight
//            self.indicator.bounds = CGRect(x: 0, y: 0, width: indicatorWidth, height: indicatorHeight)
//            self.indicator.center = CGPoint(x: button.center.x, y: self.bounds.height - indicatorHeight / 2 - 1)
//        }
//    }
//
//    /// 计算按钮宽高 (根据给出的文字、以及配置的Config参数，如：button宽度 = 文字宽度 + 按钮内部文字到button左右边框间距)
//    private func calculateButtonWidth(_ text: String) -> CGSize {
//        let textSize = (text as NSString).size(withAttributes: self.textAttrs)
//        let buttonWidth = textSize.width + 2 * config.buttonInnerTextHorizontalSpacing
//        let buttonHeight = textSize.height + 2 * config.buttonInnerTextVerticalSpacing
//        return CGSize(width: ceil(buttonWidth), height: ceil(buttonHeight))
//    }
//
//    /// 正常状态下的文字属性
//    private var textAttrs: [NSAttributedStringKey: Any] {
//        let attrs: [NSAttributedStringKey: Any] = [
//            .font: config.textFont,
//            .foregroundColor: config.textColor,
//            ]
//        return attrs
//    }
//    
//    /// 被选中时的文字属性
//    private var textSelectedAttrs: [NSAttributedStringKey: Any] {
//        let attrs: [NSAttributedStringKey: Any] = [
//            .font: config.textSelectedFont,
//            .foregroundColor: config.textSelectedColor,
//            ]
//        return attrs
//    }
//
//
//
//
//    // MARK: - 小红点
//
//    /// 为防止和其他view的tag值冲突，定义一个较大的红点的基础tag值，每个小红点的 tag = reddotBaseTag + index
//    private let reddotBaseTag: Int = 2000
//
//    ///添加红点
//    public func addReddot(at index: Int) {
//        guard index < self.buttons.endIndex else { return }
//
//        // 确保该index不存在小红点，如果有，则不再重复添加
//        guard self.viewWithTag(self.reddotBaseTag + index) == nil else { return }
//
//        // 由于一般不要在UIControl控件上添加view（有可能会发生奇怪的错误），所以还是将红点添加到MenuView上
//        let radius = config.reddotRadius
//        let buttonFrame = self.buttons[index].frame
//        let reddotFrame = CGRect(x: buttonFrame.maxX - radius * 1.5, y: buttonFrame.minY + radius * 0.5, width: radius * 2, height: radius * 2)
//
//        let reddot = UIView(frame: reddotFrame)
//        reddot.backgroundColor = UIColor.red
//        reddot.tag = self.reddotBaseTag + index
//        reddot.layer.cornerRadius = radius
//        self.scrollView.addSubview(reddot)
//    }
//
//    ///移除红点
//    public func removeReddot(at index: Int) {
//        guard index < self.buttons.endIndex else { return }
//        guard let reddot = self.viewWithTag(self.reddotBaseTag + index) else { return }
//        reddot.removeFromSuperview()
//    }
//}
