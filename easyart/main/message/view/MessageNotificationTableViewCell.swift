//
//  MessageNotificationTableViewCell.swift
//  easyart
//
//  Created by Damon on 2025/6/20.
//

import UIKit

class MessageNotificationTableViewCell: DDTableViewCell {

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
        self.contentView.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
                
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
        }
        
        self.contentView.addSubview(mArrowIcon)
        mArrowIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-13)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(5)
            make.height.equalTo(8)
        }
        
        self.contentView.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.right.equalTo(mArrowIcon.snp.left).offset(-8)
            make.centerY.equalTo(mArrowIcon)
        }
        
        self.contentView.addSubview(mRedIcon)
        mRedIcon.snp.makeConstraints { make in
            make.centerY.equalTo(mArrowIcon)
            make.right.equalTo(mDesLabel.snp.left).offset(-6)
            make.width.height.equalTo(6)
        }
    }

    func updateUI(model: MessageModel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.3
        let attributedString = NSAttributedString(string: model.content, attributes: [.foregroundColor: model.is_read ? ThemeColor.lightGray.color() : ThemeColor.black.color(), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        self.mTitleLabel.attributedText = attributedString
        
        self.mRedIcon.isHidden = model.is_read
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        label.text = "View Details".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.dd.color(hexValue: 0xA39FAC)
        return label
    }()
    
    lazy var mRedIcon: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xF50045)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var mArrowIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon-message-arrow"))
        return imageView
    }()

}
