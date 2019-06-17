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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CustomCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let customModel = dataSource[indexPath.row]
        cell.customModel = (customModel as! CustomModel)
        cell.selectBlock = { model in
            self.dataSource.replaceObject(at: indexPath.row, with: model)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataSource.removeObject(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame:self.view.bounds, style: .plain)
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var dataSource : NSMutableArray = {
        var dataSource = NSMutableArray.init(capacity: 0)
        return dataSource
    }()

    @objc func rightBarButtonItemAction() {
        
        let alertController = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "输入打卡项目"
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action:UIAlertAction) in
            let textField = alertController.textFields?.first
            let customModel = CustomModel()
            customModel.text = textField?.text
            self.dataSource.add(customModel)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

class CustomModel: NSObject {
    var text : String?
    var isSelect : Bool?
    var indexPath : NSIndexPath?
}


class CustomCell: UITableViewCell {
    
  
    var selectBlock:((_ model:CustomModel) -> Void)?
    var currentModel : CustomModel?
    
    
    // 重写父类方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.selectButton)
        self.contentView.addSubview(self.lineView)
    }
    
    // 当我们在子类定义了指定初始化器(包括自定义和重写父类指定初始化器)，那么必须显示实现，其他情况下则会隐式继承
    // 在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器：
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customModel : CustomModel! {
        willSet(newCustomModel) {
            contentLabel.text = newCustomModel.text
            selectButton.isSelected = newCustomModel.isSelect ?? false
            currentModel = newCustomModel
        }
    }
    
    lazy var  contentLabel: UILabel = {
        let contentLebel = UILabel.init()
        contentLebel.backgroundColor = UIColor.white
        contentLebel.textColor = UIColor.darkText
        let image = UIImage.init(named: "unselect")
        contentLebel.frame = CGRect.init(x: 10, y: 0, width:UIScreen.main.bounds.size.width - (image?.size.width)! - 30, height: self.contentView.bounds.height)
        return contentLebel
    }()
    
    lazy var selectButton: UIButton = {
        let selectButton = UIButton.init(type: .custom)
        let image = UIImage.init(named: "unselect")
        selectButton.setImage(image, for: .normal)
        selectButton.setImage(UIImage.init(named: "select"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectButtonAction(_:)), for: .touchUpInside)
        selectButton.frame = CGRect.init(x:self.contentLabel.frame.maxX + 10, y:(self.contentView.bounds.height-(image?.size.height)!)/2, width: (image?.size.width)!, height: (image?.size.height)!)
        return selectButton
    }()
 
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: self.contentView.bounds.maxY - 0.5, width: UIScreen.main.bounds.size.width, height: 0.5))
        lineView.backgroundColor = UIColor.black
        return lineView
    }()
    
    @objc func selectButtonAction(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        customModel.isSelect = sender.isSelected
        selectBlock!(customModel)
    }
    
}
