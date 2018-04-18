//
//  MenuViewController.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/17.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit




class MenuViewController: UIViewController, UIScrollViewDelegate {
    

    // MARK: - Public Interface
    
    /// 创建MenuViewController
    /// - Parameters:
    ///     - frame: menu view controller的视图frame
    ///     - count: 要创建的view controller个数
    ///     - 根据对应的index来创建view controller
    init(frame: CGRect, count: Int, viewControllerAtIndex: @escaping ((Int)->UIViewController?)) {
        self.count = count
        self.createViewControllerAtIndex = viewControllerAtIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    
    /// 要创建的视图控制器个数
    var count: Int
    
    /// 根据对应的index来创建view controller
    private var createViewControllerAtIndex: ((Int)->UIViewController?)
    
    /// 当前视图控制器所在的index，默认为0
    var currentIndex: Int = 0
    
    /// 存储子视图控制器的字典，key为对应的索引"index"
    var viewControllers: [Int: UIViewController] = [:]
    
    /// 水平滑动的scrollView
    private var scrollView: UIScrollView!
    
    /// 当前的子视图控制器
    var currentViewController: UIViewController? {
        if let vc = self.viewControllers[currentIndex] {
            return vc
        } else {
            return nil
        }
    }

    /// index改变了的回调
    var indexChangedCallback: ((Int)->Void)?
    
    /// 水平滑动偏移量的回调 参数：水平偏移量offsetX
    var scrolledCallback: ((CGFloat)->Void)?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white 
        
        addScrollView()
        addViewController(at: self.currentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // 清除其它所有未显示的视图
        for (index, _) in self.viewControllers {
            if index != self.currentIndex {
                self.removeViewController(at: index)
            }
        }
    }
    
    // MARK:
    func addScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        self.view.addSubview(scrollView)
    }
    
    
    /// 创建并添加一个子视图控制器到缓存数组中
    func addViewController(at index: Int) {
        guard index < count else { return }
        guard let vc = self.createViewControllerAtIndex(index) else { return }
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        self.scrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        self.viewControllers[index] = vc
    }
    
    /// 将一个视图控制器从视图和缓存数组中移除
    func removeViewController(at index: Int) {
        guard index < count else { return }
        guard let vc = self.viewControllers[index] else { return }
        vc.willMove(toParentViewController: nil)
        self.scrollView.removeFromSuperview()
        vc.removeFromParentViewController()
        self.viewControllers.removeValue(forKey: index)
    }
    
    // layout subviews
    override func viewWillLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(count), height: scrollView.bounds.height)
        
        for (index, vc) in self.viewControllers {
            vc.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
    }
    
    
    // MARK: - 横向滑动代理 UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        
        // 1. 如果滚动到还没有创建的viewController，则创建
        // 向左滚动时，即将滚动到的index
        let leftWillIndex = Int(floor(offsetX / width))
        if leftWillIndex < count && self.viewControllers[leftWillIndex] == nil {
            addViewController(at: leftWillIndex)
        }

        // 2. 向右滚动时，即将滚动到的index
        let rightWillIndex = Int(ceil(offsetX / width))
        if rightWillIndex < count && self.viewControllers[rightWillIndex] == nil {
            addViewController(at: rightWillIndex)
        }
        
        
        // 3. 是否停止时刚好滑动一页的距离(或者未换页)
        if offsetX.truncatingRemainder(dividingBy: width) == 0  { // 刚好滑动一页的距离
            let index = Int(offsetX / width)
            if index < count && self.currentIndex != index { // 页数已经改变了
                self.indexDidChange(to: index)
            }
        }

        
//        // 4. 偏移进度百分比
        let progress = offsetX / (width * CGFloat(count - 1))
        self.progressDidChange(to: progress)
        
        // 4. 水平滑动偏移量回调
        self.scrolledCallback?(offsetX)
        
        
        print("****************************************************")
        print("offsetX: \(offsetX)")
        print("width: \(width)")
        print("leftWillIndex: \(leftWillIndex)")
        print("rightWillIndex: \(rightWillIndex)")
        print("currentIndex: \(self.currentIndex)")
        print("progress: \(progress)")
        print("\n")
        print("isDragging: \(scrollView.isDragging)")
        print("isTracking: \(scrollView.isTracking)")
        print("isDecelerating: \(scrollView.isDecelerating)")
        print("****************************************************")
    }
   
    /// 当当前index发生改变时调用，用于子类继承，通知index更改了而做相应操作
    func indexDidChange(to index: Int) {
        self.currentIndex = index
        self.indexChangedCallback?(index)
    }
    
    /// 偏移进度百分比
    func progressDidChange(to progress: CGFloat) {
        
    }
    
    deinit {
        print("\(self) deinit")
    }
}
