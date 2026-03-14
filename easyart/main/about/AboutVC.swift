//
//  AboutVC.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit

class AboutVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeColor.main.color()
        self.loadBarTitle(title: "About Us".localString, textColor: ThemeColor.black.color())
//        self.navigationBarTransparentType = .none
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        self.mSafeView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(25)
            make.top.equalToSuperview().offset(60)
        }
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mImageView.snp.bottom).offset(60)
        }
        
        self.mSafeView.addSubview(mTitleLabel2)
        mTitleLabel2.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mTitleLabel3)
        mTitleLabel3.snp.makeConstraints { make in
            make.left.right.equalTo(mTitleLabel)
            make.top.equalTo(mTitleLabel2.snp.bottom).offset(30)
        }
    }
    

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_logo"))
        return imageView
    }()

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Easyart is an art e-commerce and content operation platform that integrates the collection of modern and contemporary art works, promotion of young artists, and new retail of light art. It has established long-term and close strategic partnerships with young artists, galleries, art fairs, and collectors from China and abroad.".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        return label
    }()
    
    lazy var mTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Our aim is to support more young artists, cultivate the concept and aesthetic forms of mass art consumption, remove the stratification of art consumption circles, expand the contemporary art market at home and abroad, and provide a full range of art investment and art consumption services for professional art enthusiasts.".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        return label
    }()
    
    lazy var mTitleLabel3: UILabel = {
        let label = UILabel()
        label.text = "At Easyart, art institutions and artists can settle in by themselves, and offer their works. While customers can purchase them online. We believe that buying artworks should be as enjoyable as art life, with no falsehood or isolation, only great and simple art itself.".localString
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.dd.color(hexValue: 0xffffff)
        return label
    }()
}
