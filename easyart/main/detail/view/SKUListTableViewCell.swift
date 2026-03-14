//
//  SKUListTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import SwiftyJSON

class SKUListTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        mTitleLabel.textColor = selected ? ThemeColor.black.color() : ThemeColor.gray.color()
        mDesLabel.textColor = selected ? ThemeColor.black.color() : ThemeColor.gray.color()
        mImageView.image = selected ? UIImage(named: "icon_selected_blue") : UIImage(named: "icon_normal")
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(mImageView.snp.right).offset(12)
            make.right.equalToSuperview()
        }
        
        self.contentView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func updateUI(model: JSON) {
        var sizeLW = ""
        if model["height"].intValue > 0 {
            sizeLW = "\(model["length"].intValue)" + " × " + "\(model["width"].intValue)" + " × " + "\(model["height"].intValue)" + " cm"
        } else {
            sizeLW = "\(model["length"].intValue)" + " × " + "\(model["width"].intValue)" + " cm"
        }
        if model["weight"].intValue > 0 {
            sizeLW = sizeLW + "\n" + "Weight".localString + " " + "\(model["weight"].intValue)" + " kg"
        }
        //装裱
        var packageSize = ""
        if (model["mount_type"].intValue == 2) {
            if model["height_mount"].intValue > 0 {
                packageSize = ", " + "Frame" +  " " + "\(model["length_mount"].intValue)" + " × " + "\(model["width_mount"].intValue)" + " × " + "\(model["height_mount"].intValue)" + " cm"
            } else {
                packageSize = ", " + "Frame" +  " " + "\(model["length_mount"].intValue)" + " × " + "\(model["width_mount"].intValue)" + " cm"
            }
        }
        
        self.mTitleLabel.text = "Format".localString + " " + sizeLW + packageSize
        //印数
        var edition = ""
        if model["number_type"].intValue != ArtistNumberType.unique.rawValue &&  model["number_type"].intValue != ArtistNumberType.open.rawValue {
            edition = "Edition of".localString + " " + model["stock_num"].stringValue
        }
        self.mDesLabel.attributedText = NSMutableAttributedString(string: edition)
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_normal"))
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
}
