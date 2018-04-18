//
//  HomeChildViewController2.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/18.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class HomeChildViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var name: String = ""
    var age: Int = 0
    
    let datas: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    
    var tableView: UITableView!
    
    /// tableview起始的偏移量
    var startOffsetY: CGFloat = -300
    /// tableview刚好把menuview顶到顶部时的偏移量
    var endOffsetY: CGFloat = -50
    /// 是否是当前正在显示的ViewController，由于设置其偏移量会导致“调用scrollViewDidScroll方法”，只有是当前viewController正在显示，才调用HomeChildViewControllerScrollDelegate，否则位置会出错
    var isCurrent: Bool = false
    
    weak var scrollDelegate: HomeChildViewControllerScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), style: .plain)
        tableView.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(tableView)
        
        
        print("tableView.contentInset: \(tableView.contentInset)")
        if #available(iOS 11.0, *) {
            print("tableView.adjustedContentInset: \(tableView.adjustedContentInset)")
        } else {
            // Fallback on earlier versions
        }
        tableView.contentInset = UIEdgeInsets(top: -self.startOffsetY, left: 0, bottom: 0, right: 0)
        
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        footerView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        tableView.tableFooterView = footerView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(datas[indexPath.row])"
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    // 不能在“scrollViewDidScroll”方法中处理，因为代理中设置子视图的contentOffset仍会回调子视图控制器的“scrollViewDidScroll”方法，造成死递归。
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if self.isCurrent {     // 由于设置其偏移量会导致“调用scrollViewDidScroll方法”，只有是当前viewController正在显示，才调用HomeChildViewControllerScrollDelegate，否则位置会出错
            self.scrollDelegate?.childViewControllerDidScroll(scrollView.contentOffset.y - startOffsetY)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
        self.scrollDelegate?.childViewControllerEndScroll(startOffsetY - scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        
        // 参数decelerate: true if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation. If the value is false, scrolling stops immediately upon touch-up.
        // "decelerate = true" 表示用户停止了拖拽，但是scrollView仍将做减速滑动
        // "decelerate = flase" 表示用户停止了拖拽，并且scrollView立刻也停止了
        if decelerate == false {
            self.scrollDelegate?.childViewControllerEndScroll(startOffsetY - scrollView.contentOffset.y)
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}
