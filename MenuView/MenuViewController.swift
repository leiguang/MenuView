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
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    var viewControllers: [UIViewController]
    
    
    private var scrollView: UIScrollView!
    private var hasInitializeds: [Bool] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white 
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup UI
    func setupUI() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(self.viewControllers.count), height: scrollView.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        self.view.addSubview(scrollView)
        
        //
        for (index, vc) in self.viewControllers.enumerated() {
            let frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            self.addViewController(vc, frame: frame)
        }

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
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func childScrollViewDidScroll(_ offset: CGPoint) {
        
    }

}
