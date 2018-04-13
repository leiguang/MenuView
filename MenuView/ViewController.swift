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
        
        // 1.
        var rect = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: 44)
        let menu1 = MenuView(frame: rect)
        menu1.setTexts(["语文"])
        view.addSubview(menu1)
        
        
        // 2.
        rect.origin.y += 90
        let menu2 = MenuView(frame: CGRect(x: 60, y: rect.origin.y, width: view.bounds.size.width-120, height: 44))
        menu2.setTexts(["语文", "数学"]) { (config) in
            config.backgroundColor = .purple
            config.buttonBorderColor = .yellow
            config.buttonSelectedBorderColor = .red
            config.buttonBorderWidth = 1.0
            config.buttonSelectedBorderWidth = 1.0
            config.buttonCorner = true
        }
        view.addSubview(menu2)
        
        
        // 3.
        rect.origin.y += 90
        let menu3 = MenuView(frame: rect)
        menu3.setTexts(["语文", "数学", "英语政治"])
        view.addSubview(menu3)
 
        
        // 4.
        rect.origin.y += 90
        menu4 = MenuView(frame: rect)
        menu4.setTexts(["语文0", "数学啊1", "英语政治2", "化学3", "生物4", "地理历史5", "思想道德6"])
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
        
        
        // 5.
        rect.origin.y += 90
        let button = UIButton(type: .system)
        button.frame = rect
        button.backgroundColor = .blue
        button.setTitle("点这儿选中最后一排MenuView的第3个按钮“英语政治2”", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        view.addSubview(button)
        
    
        
    }
    
    @objc func tapButton() {
        menu4.selectButtonAt(2)
    }

    func showMessage(_ text: String) {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .cyan
        label.center = CGPoint(x: view.center.x, y: view.bounds.height - 150)
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
        label.center = CGPoint(x: view.center.x, y: view.bounds.height - 250)
        label.bounds.size = CGSize(width: 150, height: 44)
        view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            label.removeFromSuperview()
        }
    }

}

