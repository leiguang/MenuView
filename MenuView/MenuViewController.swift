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
    ///     - viewControllers: 要创建的view controllers数组
    init(frame: CGRect, viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    /// 子视图控制器数组
    var viewControllers: [UIViewController]
    /// 当前视图控制器所在的index
    var currentIndex: Int = 0
    /// 当前的子视图控制器
    var currentViewController: UIViewController { return self.viewControllers[currentIndex] }
    
    
    
    
    private var scrollView: UIScrollView!
    private var hasInitializeds: [Bool] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        view.backgroundColor = .white 
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: create UI elements
    func setupUI() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        self.view.addSubview(scrollView)
        
        //
        for (index, vc) in self.viewControllers.enumerated() {
            self.addChildViewController(vc)
            self.scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
        
    }
    
    // layout subviews
    override func viewWillLayoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(self.viewControllers.count), height: scrollView.bounds.height)
        
        for (index, vc) in self.viewControllers.enumerated() {
            vc.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        }
    }
    
    @objc func tapButton() {
        print("tap button")
    }
    
    /// 添加一个子视图控制器，将子视图器的view添加到scrollView上，并指定其frame
    /// - Parameters:
    ///     - vc: 要添加的子视图控制器
    ///     - frame: 子视图控制器的frame
    private func addViewController(_ vc: UIViewController, frame: CGRect) {
        self.addChildViewController(vc)
        vc.view.frame = frame
        self.scrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

    /// 移除一个子视图控制器，并将子视图控制器的view从ScrollView中移除
    /// - Parameters:
    ///     - vc: 要移除的子视图控制器
    private func removeViewController(_ vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        self.scrollView.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    
    //
//    private func hasInitialized(at index: Int) -> Bool {
//        return true
//    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if self.currentIndex != index {
            self.currentIndex = index
            self.currentIndexDidChange(to: index)
        }
//        print("currentIndex: \(self.currentIndex)")
    }
   
    /// 当当前index发生改变时调用，用于子类继承，通知index更改了而做相应操作
    func currentIndexDidChange(to index: Int) {
        
    }
}
