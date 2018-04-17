//
//  MenuSingleViewController.swift
//  MenuView
//
//  Created by 雷广 on 2018/4/17.
//  Copyright © 2018年 雷广. All rights reserved.
//

import UIKit

class MenuSingleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let datas: [Int] = [0, 1, 2, 3, 4, 5, 6]
    
    var tableView: UITableView!

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
        tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        footerView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        tableView.tableFooterView = footerView
        
        let v = UIView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        v.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        v.isUserInteractionEnabled = false
        self.view.addSubview(v)
        
        let button = UIButton(frame: CGRect(x: 100, y: 0, width: 100, height: 50))
        button.setTitle("button", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        v.addSubview(button)
    }
    
    @objc func tapButton() {
        print("tap button")
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
}
