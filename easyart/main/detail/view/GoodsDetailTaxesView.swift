//
//  GoodsDetailTaxesView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit

class GoodsDetailTaxesView: DDView {

    override func createUI() {
        super.createUI()
        let topLine = UIView()
        topLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(topLine.snp.bottom).offset(16)
        }
        
        self.addSubview(mDesLabel)
        mDesLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
        
    }
    
   //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Shipping and taxes".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mDesLabel: UILabel = {
        let label = UILabel()
        let text = """
        Shipping from China
        
        Shipping:
        Artwork prices exclude shipping. We'll contact you post-order to 
        confirm shipping details and costs.
        
        Customs and VAT:
        Customs duties and VAT are additional and not included in the price. 
        These may apply based on your country/region's policies and could 
        be calculated at checkout. Contact us for details.
        """
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        let attributed = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.attributedText = attributed
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = ThemeColor.gray.color()
        return label
    }()

}
