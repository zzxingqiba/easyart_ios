//
//  ArtistEditPublishTipsVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON

class ArtistEditPublishTipsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
        }
        
        self.mSafeView.addSubview(mTipView)
        mTipView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
            make.height.greaterThanOrEqualTo(1)
        }
        
        self.mSafeView.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mTipView.snp.bottom).offset(100)
            make.height.equalTo(50)
        }
        
    }
    
    
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "It's easy to sell on Easyart".localString
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTipView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "New Submission".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
    

}

extension ArtistEditPublishTipsVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = ArtistEditVC(bottomPadding: 80)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func _loadData() {
        for view in self.mTipView.subviews {
            view.removeFromSuperview()
        }
        
        _ = DDAPI.shared.request("home/stepInfo").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            self.mTitleLabel.text = json["title"].stringValue
            let stepList = json["step_list"].arrayValue
            var posView: UIView?
            for i in 0..<stepList.count {
                let step = stepList[i]
                let view = ArtistEditPublishTipsItemView()
                view.mTitleLabel.text = step["title"].stringValue
                view.mDesLabel.text = step["content"].stringValue
                view.mImageView.kf.setImage(with: URL(string: step["pic_url"].stringValue))
                self.mTipView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    if let view = posView {
                        make.top.equalTo(view.snp.bottom).offset(35)
                    } else {
                        make.top.equalToSuperview()
                    }
                }
                if i == stepList.count - 1 {
                    view.snp.makeConstraints { make in
                        make.bottom.equalToSuperview()
                    }
                }
                posView = view
            }
            
        })
    }
}
