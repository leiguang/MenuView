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

    var containerView: UIView?
    
    /// container view 初始位置
    let containerViewStartFrame: CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 300)
    /// container view 滑到顶部后，定在顶部的位置
    let containerViewEndFrame: CGRect = CGRect(x: 0, y: -250, width: kScreenWidth, height: 300)
    
    let buttonHeight: CGFloat = 50
    
    /// 存储上次偏移量，用于创建新的子视图控制器时刷新
    var lastOffsetY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        containerView = UIView(frame: containerViewStartFrame)
        containerView!.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        containerView!.isUserInteractionEnabled = false
        self.view.addSubview(containerView!)

        let button = UIButton(frame: CGRect(x: 100, y: 250, width: 100, height: buttonHeight))
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        button.setTitle("button", for: .normal)
        containerView!.addSubview(button)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func indexDidChange(to index: Int) {
        super.indexDidChange(to: index)
        
        for (index, viewController) in self.viewControllers {
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
    
    /// 需要重写父类此方法：
    /// 1. 由于之前刷新同步tableView上下偏移量时 子视图控制器可能还未创建，所以需要在创建时再刷新一遍
    /// 2. 每次都要添加代理
    override func addViewController(at index: Int) {
        super.addViewController(at: index)
        
        self.childViewControllerEndScroll(self.lastOffsetY)
        
        guard index < count else { return }
        if let vc = viewControllers[index] as? HomeChildViewController {
            vc.scrollDelegate = self
        } else if let vc = viewControllers[index] as? HomeChildViewController2 {
            vc.scrollDelegate = self
        }
    }
    
    
    // MARK: - HomeChildViewController scroll delegate
    /// 子视图控制器上下滚动时调用
    func childViewControllerDidScroll(_ offsetY: CGFloat) {
        print("offsetY: \(offsetY)")
        // container view
        var frame = containerViewStartFrame
        frame.origin.y -= offsetY
        
        if frame.origin.y >= containerViewEndFrame.origin.y {
            UIView.animate(withDuration: 0.25) {
                self.containerView?.frame = frame
            }
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.containerView?.frame = self.containerViewEndFrame
            }, completion: nil)
        }
        
    }

    /// 子视图控制器上下滑动停止时调用
    func childViewControllerEndScroll(_ offsetY: CGFloat) {
        print("offsetY: \(offsetY)")
        self.lastOffsetY = offsetY
        
        if containerView?.frame == containerViewEndFrame {
            // 如果滑到了顶端，如果其他子视图没到顶端的话，就要设置其偏移到顶端，否则就不用设置了.
            // 子视图
            for (index, viewController) in self.viewControllers {
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
            for (index, viewController) in self.viewControllers {
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
    
    deinit {
        print("\(self) deinit")
    }
}
