//
//  HomeViewController.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/17.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

/// 首页用到，每次HomeViewController的子视图控制器上下滑动时，就调用此方法来让HomeViewController跟着做调整
protocol HomeChildViewControllerScrollDelegate: class {
    /// 子视图控制器滚动时调用
    /// - Parameters:
    ///     - offsetY: 子视图控制器滚动时，内容在y轴相对于它起始点startOffsetY的偏移量，滑动时，内容偏移量在起始点startOffsetY上方为负值，下方为正值
    func childViewControllerDidScroll(_ offsetY: CGFloat)
    
    /// 子视图控制器滚动结束时调用
    /// - Parameters:
    ///     - offsetY: 子视图控制器滚动结束时，内容在y轴相对于它起始点startOffsetY的偏移量，滑动时，内容偏移量在起始点startOffsetY上方为负值，下方为正值
    func childViewControllerEndScroll(_ offsetY: CGFloat)
}


class HomeViewController: MenuViewController, HomeChildViewControllerScrollDelegate {

    var containerView: UIView!
    
    /// container view 初始位置
    let containerViewStartFrame: CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 300)
    /// container view 滑到顶部后，定在顶部的位置
    let containerViewEndFrame: CGRect = CGRect(x: 0, y: -250, width: kScreenWidth, height: 300)
    
    let buttonHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for (_, viewController) in self.viewControllers.enumerated() {
            if let vc = viewController as? HomeChildViewController {
                vc.scrollDelegate = self
            } else if let vc = viewController as? HomeChildViewController2 {
                vc.scrollDelegate = self
            }
        }
        
        containerView = UIView(frame: containerViewStartFrame)
        containerView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        containerView.isUserInteractionEnabled = false
        self.view.addSubview(containerView)

        let button = UIButton(frame: CGRect(x: 100, y: 250, width: 100, height: buttonHeight))
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        button.setTitle("button", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        containerView.addSubview(button)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func currentIndexDidChange(to index: Int) {
        for (index, viewController) in self.viewControllers.enumerated() {
            if self.currentIndex == index {
                if let vc = viewController as? HomeChildViewController {
                    vc.isCurrent = true
                } else if let vc = viewController as? HomeChildViewController2 {
                    vc.isCurrent = true
                }
            } else {
                if let vc = viewController as? HomeChildViewController {
                    vc.isCurrent = false
                } else if let vc = viewController as? HomeChildViewController2 {
                    vc.isCurrent = false
                }
            }
            
        }
    }
    
    // MARK: - HomeChildViewController scroll delegate
    func childViewControllerDidScroll(_ offsetY: CGFloat) {
        print("offsetY: \(offsetY)")
        // container view
        var frame = containerViewStartFrame
        frame.origin.y -= offsetY
        
        if frame.origin.y >= containerViewEndFrame.origin.y {
            UIView.animate(withDuration: 0.25) {
                self.containerView.frame = frame
            }
        } else {
            containerView.frame = containerViewEndFrame
        }
        
    }

    func childViewControllerEndScroll(_ offsetY: CGFloat) {
        print("offsetY: \(offsetY)")
        
        if containerView.frame == containerViewEndFrame {
            // 如果滑到了顶端，如果其他子视图没到顶端的话，就要设置其便宜到顶端，否则就不用设置了.
            // 子视图
            for (index, viewController) in self.viewControllers.enumerated() {
                if self.currentIndex != index, let vc = viewController as? HomeChildViewController {
                    if vc.tableView.contentOffset.y < vc.endOffsetY {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.endOffsetY )
                    }
                    
                } else if self.currentIndex != index, let vc = viewController as? HomeChildViewController2 {
                    if vc.tableView.contentOffset.y < vc.endOffsetY {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.endOffsetY )
                    }
                    
                }
            }
            
        } else {
            // 还没有滑到顶端
            // 子视图
            for (index, viewController) in self.viewControllers.enumerated() {
                if self.currentIndex != index, let vc = viewController as? HomeChildViewController {
                    if vc.tableView.contentOffset.y > vc.endOffsetY {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.tableView.contentOffset.y)
                    } else {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.startOffsetY - offsetY)
                    }
                    
                } else if self.currentIndex != index, let vc = viewController as? HomeChildViewController2 {
                    if vc.tableView.contentOffset.y > vc.endOffsetY {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.tableView.contentOffset.y)
                    } else {
                        vc.tableView.contentOffset = CGPoint(x: 0, y: vc.startOffsetY - offsetY)
                    }
                }
            }
        }
        
        
    }
}
