//
//  HDSheetTableViewCell.swift
//  HDPopViewDemo
//
//  Created by Damon on 2020/12/26.
//

import UIKit
import DDUtils

class HDSheetTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func updateUI(title: NSAttributedString) {
        mTitleLabel.attributedText = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 16)
        tLabel.textColor = UIColor.dd.color(hexValue: 0x0091FF)
        return tLabel
    }()
}
