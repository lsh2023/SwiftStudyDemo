//
//  CustomCell.swift
//  SwiftStudyDemo
//
//  Created by u1city on 2019/6/18.
//  Copyright © 2019 lsh. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
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
        selectButton.frame = CGRect.init(x:self.contentLabel.frame.maxX + 10, y:(self.contentView.bounds.height-(image?.size.height)!)/2, width: (image?.size.width)!, height: (image?.size.height)!)
        selectButton.isUserInteractionEnabled = false
        return selectButton
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: self.contentView.bounds.maxY - 0.5, width: UIScreen.main.bounds.size.width, height: 0.5))
        lineView.backgroundColor = UIColor.black
        return lineView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
