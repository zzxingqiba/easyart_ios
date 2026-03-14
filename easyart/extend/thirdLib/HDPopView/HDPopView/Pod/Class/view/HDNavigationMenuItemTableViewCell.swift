//
//  HDNavigationMenuItemTableViewCell.swift
//  HDPopView
//
//  Created by Damon on 2022/3/15.
//

import UIKit

class HDNavigationMenuItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.p_createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func p_createUI() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.mImageView)
        self.mImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(24)
        }
        
        self.contentView.addSubview(self.mTitleLabel)
        self.mTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.mImageView.snp.right).offset(10)
        }
    }
    
    func updateUI(image: UIImage?, title: NSAttributedString?) {
        mTitleLabel.attributedText = title
        mImageView.image = image
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.dd.color(hexValue: 0x0091FF)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
