//
//  ViewController.swift
//  SwiftStudyDemo
//
//  Created by u1city on 2019/6/17.
//  Copyright © 2019 lsh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonItemAction))
       self.view.addSubview(tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(saveAction), name:NSNotification.Name(rawValue: "SAVEDATA"), object: nil)
        
    }
    
    @objc func saveAction() {
//        UserDefaults.standard.set(dataSource, forKey: "SaveData")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let headerModel : CustomHeaderModel
        if dataSource.count > 0 {
           headerModel  = dataSource[section] as! CustomHeaderModel
            return headerModel.headerArray?.count ?? 0
        }else {
           return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let headerModel : CustomHeaderModel = dataSource[indexPath.section] as! CustomHeaderModel
        let customModel = headerModel.headerArray?[indexPath.row]
        cell.customModel = (customModel as! CustomModel)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let headerModel : CustomHeaderModel = dataSource[indexPath.section] as! CustomHeaderModel
        let customModel : CustomModel = headerModel.headerArray?[indexPath.row] as! CustomModel
        customModel.isSelect = !customModel.isSelect!
        headerModel.headerArray?.replaceObject(at: indexPath.row, with: customModel)
        self.dataSource.replaceObject(at: indexPath.section, with:headerModel)
        tableView.reloadRows(at: [indexPath], with: .left)
    
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let headerModel : CustomHeaderModel = dataSource[indexPath.section] as! CustomHeaderModel
        headerModel.headerArray?.removeObject(at: indexPath.row)
        self.dataSource.replaceObject(at: indexPath.section, with: headerModel)
        
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let headerModel : CustomHeaderModel = dataSource[section] as! CustomHeaderModel
        
        let label = UILabel.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        label.text = headerModel.time
        label.textColor = .darkText
        label.backgroundColor = #colorLiteral(red: 1, green: 0.9406069163, blue: 0.2816785727, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame:self.view.bounds, style: .plain)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9446779822, green: 0.9446779822, blue: 0.9446779822, alpha: 1)
        return tableView
    }()
    
    lazy var dataSource : NSMutableArray = {
        var dataSource = NSMutableArray.init(capacity: 0)
        return dataSource
    }()

    @objc func rightBarButtonItemAction() {
        
        let saveTime : String = UserDefaults.standard.object(forKey: "SaveTime") as? String ?? ""
        let saveDateArray : Array = saveTime.components(separatedBy: " ")
        
        let saveDate : String
        if saveDateArray.count > 1 {
            saveDate = saveDateArray[1]
        }else {
            saveDate = ""
        }
        
        let currentArray : Array = currentTime().components(separatedBy: " ")
        let currentDate : String
        if currentArray.count > 1 {
            currentDate = currentArray[1]
        }else {
            currentDate = ""
        }
        
        let alertController = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "输入内容"
            textField.keyboardType = .default
            textField.returnKeyType = .done
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action:UIAlertAction) in
            let textField = alertController.textFields?.first
            
            let customModel = CustomModel()
            customModel.text = textField?.text
            customModel.isSelect = false
            if saveDate != currentDate {
                let customHeaderModel = CustomHeaderModel()
                customHeaderModel.headerArray = NSMutableArray.init(capacity: 0)
                customHeaderModel.time = currentDate
                customHeaderModel.headerArray?.add(customModel)
                self.dataSource.add(customHeaderModel)
            } else {
                let customHeaderModel : CustomHeaderModel
                if self.dataSource.count > 0 {
                    customHeaderModel = self.dataSource.lastObject as! CustomHeaderModel
                    customHeaderModel.headerArray?.add(customModel)
                    self.dataSource.replaceObject(at: self.dataSource.count - 1, with: customHeaderModel)
                }else {
                    let customHeaderModel = CustomHeaderModel()
                    customHeaderModel.headerArray = NSMutableArray.init(capacity: 0)
                    customHeaderModel.time = currentDate
                    customHeaderModel.headerArray?.add(customModel)
                    self.dataSource.add(customHeaderModel)
                }
            }
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        UserDefaults.standard.set(currentTime(), forKey: "SaveTime")
        
    }
    
    func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    
}

