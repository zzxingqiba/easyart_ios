//
//  DDPayResultVC.swift
//  easyart
//
//  Created by Damon on 2024/9/30.
//

import UIKit

class DDPayResultVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(95)
        }
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mImageView.snp.bottom).offset(20)
        }
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "home_wancheng"))
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.text = "The order has been completed".localString
        tLabel.textColor = ThemeColor.black.color()
        tLabel.font = .systemFont(ofSize: 17, weight: .medium)
        return tLabel
    }()
    
    lazy var mTipLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 3
        tLabel.textAlignment = .center
        tLabel.textColor = ThemeColor.black.color()
        tLabel.font = .systemFont(ofSize: 13, weight: .medium)
        //
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .center
        let attributed = NSMutableAttributedString(string: "Please pay to below account within 24 hours.".localString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.main.color()])
        let tip = NSAttributedString(string: "\n收到汇款后我们会及时与您取得联系".localString)
        attributed.append(tip)
        attributed.addAttributes([ NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributed.string.count))
        tLabel.attributedText = attributed
        return tLabel
    }()
    
    lazy var mConfirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Return to the homepage".localString, for: .normal)
        button.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.black.color()), for: .normal)
        button.setBackgroundImage(UIImage.dd.getImage(color: ThemeColor.gray.color()), for: .disabled)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
}

extension DDPayResultVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
//            self.navigationController?.popToRootViewController(animated: true)
            let sheet = DDSheetView()
            sheet.mTitleLabel.text = "Do you want to delete the order".localString
            DDPopView.show(view: sheet, animationType: .bottom)
        })
        
    }
}
