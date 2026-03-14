//
//  ArtistEditImageTipsVC.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit
import SwiftyJSON

class ArtistEditImageTipsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(25)
        }
        
        self.mSafeView.addSubview(mTipView)
        mTipView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
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
        label.text = "Three tips to improve your chancesof selling".localString
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
        button.mTitleLabel.text = "Close".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
    

}

extension ArtistEditImageTipsVC {
    func _bindView() {
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func _loadData() {
        for view in self.mTipView.subviews {
            view.removeFromSuperview()
        }
        
        _ = DDAPI.shared.request("home/tipsInfo").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            self.mTitleLabel.text = json["title"].stringValue
            let tipList = json["tip_list"].arrayValue
            
            var posView: UIView?
            for i in 0..<tipList.count {
                let tip = tipList[i]
                let view = ArtistEditTipsImageListView()
                view.updateImageList(images: tip["pic_list"].arrayValue.map({ pic in
                    return pic.stringValue
                }))
                self.mTipView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    if let view = posView {
                        make.top.equalTo(view.snp.bottom).offset(20)
                    } else {
                        make.top.equalToSuperview()
                    }
                }
                //文字
                let label = UILabel()
                label.numberOfLines = 0
                label.text = tip["content"].stringValue
                label.font = .systemFont(ofSize: 13)
                label.textColor = ThemeColor.black.color()
                self.mTipView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalTo(view.snp.bottom).offset(20)
                }
                
                if i == tipList.count - 1 {
                    label.snp.makeConstraints { make in
                        make.bottom.equalToSuperview()
                    }
                }
                posView = label
            }
        })
    }
}

