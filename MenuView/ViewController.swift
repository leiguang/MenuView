//
//  ViewController.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/12.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let menuView = MenuView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
        menuView.backgroundColor = .red
        menuView.config.buttonBackgroundColor = .green 
        menuView.texts = ["语文", "数学", "英语", "生物", "地理", "化学", "政治", "历史", "思想道德"]
        self.view.addSubview(menuView)
    }


}

