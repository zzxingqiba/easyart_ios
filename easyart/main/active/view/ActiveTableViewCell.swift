//
//  ActiveTableViewCell.swift
//  easyart
//
//  Created by Damon on 2024/10/28.
//

import UIKit
import SwiftyJSON

class ActiveTableViewCell: DDTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func updateUI(model: JSON) {
        self.mImageView.kf.setImage(with: URL(string: model["img"].stringValue))
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
}
