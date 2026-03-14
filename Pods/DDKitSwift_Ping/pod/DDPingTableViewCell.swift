//
//  DDPingTableViewCell.swift
//  DDKitSwift_Ping
//
//  Created by Damon on 2025/4/14.
//

import UIKit

class DDPingTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(mTextLabel)
        mTextLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        mTextLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        mTextLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        mTextLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        mTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(text: String) {
        mTextLabel.text = text
    }

    //MARK: UI
    lazy var mTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.dd.color(hexValue: 0x000000)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
