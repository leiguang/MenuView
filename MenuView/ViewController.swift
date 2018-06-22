//
//  ViewController.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menu4: MenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuViewDemo()
        
        // Menu View Controller
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "MenuViewController", style: .plain, target: self, action: #selector(tapMenuViewController))
    }
    
    @objc func tapMenuViewController() {

        let vc = HomeChildViewController()
        vc.isCurrent = true 
        let vc2 = HomeChildViewController2()
        let vc3 = HomeChildViewController()
        let frame = CGRect(x: 0, y: kNaviHeight, width: kScreenWidth, height: kScreenHeight - kNaviHeight)
        let menuVC = HomeViewController(frame: frame, count: 3) { (index) -> UIViewController? in
            switch index {
            case 0:
                print("case 0")
                return vc
            case 1:
                print("case 1")
                return vc2
            case 2:
                print("case 2")
                return vc3
            default:
                print("default")
                return nil
            }
        }

        self.show(menuVC, sender: nil)
    }
    
    func menuViewDemo() {
        // 1.
        var rect = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 44)
        let menu1 = MenuView(frame: rect)
        let items = MenuViewItem.createItems(["语文"])
        menu1.setItems(items)
        view.addSubview(menu1)
        
        
        // 2.
        rect.origin.y += 90
        let menu2 = MenuView(frame: CGRect(x: 60, y: rect.origin.y, width: view.bounds.size.width-120, height: 44))
//        let items2 = MenuViewItem.createItems(["语文", "数学"]) { (config) in
        let items2 = MenuViewItem.createItems(["Part1", "Part2&3"]) { (config) in
            config.normalTextColor = .green
            config.selectedTextColor = .red
            config.normalBackgroundColor = .purple
            config.selectedBackgroundColor = .blue
            config.normalBorderWidth = 1.0
            config.selectedBorderWidth = 1.0
            config.normalBorderColor = .orange
            config.selectedBorderColor = .cyan
            config.needCorner = true
        }
        menu2.setItems(items2)
        view.addSubview(menu2)


        // 3.
        rect.origin.y += 90
        let menu3 = MenuView(frame: rect)
        let items3 = MenuViewItem.createItems(["语文", "数学", "英语政治"])
        menu3.setItems(items3)
        view.addSubview(menu3)


        // 4.
        rect.origin.y += 90
        menu4 = MenuView(frame: rect)
        let items4 = MenuViewItem.createItems(["语文0", "数学啊1", "英语政治2", "化学3", "生物4", "地理历史5", "思想道德6"])
        menu4.setItems(items4)
        menu4.selectedCallback = { index in
            self.showMessage("点击index：\(index)")
        }
        menu4.selectedRepeatedCallback = { index in
            self.showMessage2("重复选中index：\(index)")
        }
        menu4.selectedIndexChangedCallback = { index in
            self.showMessage2("切换到index: \(index)")
        }
        view.addSubview(menu4)
        
        
        
        
        
        // 按钮 选中
        rect.origin.y += 90
        let button1 = UIButton(type: .system)
        button1.frame = rect
        button1.backgroundColor = .blue
        button1.setTitle("选中最后一排MenuView的第3个按钮“英语政治2”", for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button1.setTitleColor(.white, for: .normal)
        button1.addTarget(self, action: #selector(tapSelect), for: .touchUpInside)
        view.addSubview(button1)
        // 按钮 添加小红点
        rect.origin.y += 50
        let button2 = UIButton(type: .system)
        button2.frame = rect
        button2.backgroundColor = .blue
        button2.setTitle("为最后一排的index=2 添加小红点", for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button2.setTitleColor(.white, for: .normal)
        button2.addTarget(self, action: #selector(tapAddReddot), for: .touchUpInside)
        view.addSubview(button2)
        // 按钮 移除小红点
        rect.origin.y += 50
        let button3 = UIButton(type: .system)
        button3.frame = rect
        button3.backgroundColor = .blue
        button3.setTitle("为最后一排的index=2 移除小红点", for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button3.setTitleColor(.white, for: .normal)
        button3.addTarget(self, action: #selector(tapRemoveReddot), for: .touchUpInside)
        view.addSubview(button3)
    }
    
    @objc func tapSelect() {
        menu4.selectItemAt(2)
    }
    
    @objc func tapAddReddot() {
        menu4.addReddot(at: 2)
    }
    
    @objc func tapRemoveReddot() {
        menu4.removeReddot(at: 2)
    }

    func showMessage(_ text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .cyan
        label.center = CGPoint(x: view.center.x, y: view.bounds.height - 80)
        label.bounds.size = CGSize(width: 150, height: 44)
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            label.removeFromSuperview()
        }
    }
    
    func showMessage2(_ text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .cyan
        label.center = CGPoint(x: view.center.x, y: view.bounds.height - 150)
        label.bounds.size = CGSize(width: 150, height: 44)
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            label.removeFromSuperview()
        }
    }

}

