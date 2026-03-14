//
//  SettleInResultVC.swift
//  easyart
//
//  Created by Damon on 2024/12/16.
//

import UIKit
import DDUtils

enum SettleInResultStatus {
    case process
    case success
    case failed
}

class SettleInResultVC: BaseVC {
    var status: SettleInResultStatus = .process {
        didSet {
            switch status {
            case .process:
                mImageView.image = UIImage(named: "me_gou")
                mTitleLabel.text = "Your artist profile has been submitted.".localString
                mTipLabel.text = "The verification process is expected to be completed within 3 business days.".localString
                mTipLabel.textColor = UIColor.dd.color(hexValue: 0xA39FAC)
                mTipLabel.font = .systemFont(ofSize: 13)
                mBottomButton.setTitle("Completed".localString, for: .normal)
            case .success:
                mImageView.image = UIImage(named: "me_gou")
                mTitleLabel.text = "Congratulations!Your applicationhas been approved.".localString
                mTipLabel.text = "Welcome to the &asxaxt".localString
                mTipLabel.textColor = ThemeColor.main.color()
                mTipLabel.font = .systemFont(ofSize: 18, weight: .bold)
                mBottomButton.setTitle("Publish Artwork".localString, for: .normal)
            case .failed:
                mImageView.image = UIImage(named: "me_cha")
                mTitleLabel.text = "Sorry! Your submission failed.".localString
                mTipLabel.text = "Please modify the information and resubmit".localString
                mTipLabel.textColor = UIColor.dd.color(hexValue: 0xF50045)
                mTipLabel.font = .systemFont(ofSize: 13)
                mBottomButton.setTitle("Re-submit".localString, for: .normal)
                mLeftButton.snp.updateConstraints { make in
                    make.width.equalTo(UIScreenWidth / 2)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(50)
        }
        
        self.mSafeView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mImageView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.mSafeView.addSubview(mTipLabel)
        mTipLabel.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.view.addSubview(mLeftButton)
        mLeftButton.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
            if (self.status == .failed) {
                make.width.equalTo(UIScreenWidth / 2)
            } else {
                make.width.equalTo(0)
            }
        }
        mLeftButton.addSubview(mLeftButtonLine)
        mLeftButtonLine.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
        self.view.addSubview(mBottomButton)
        mBottomButton.snp.makeConstraints { make in
            make.left.equalTo(mLeftButton.snp.right)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
        }
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = ThemeColor.main.color()
        return label
    }()
    
    lazy var mBottomButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.black.color()
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    lazy var mLeftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel".localString, for: .normal)
        button.backgroundColor = ThemeColor.white.color()
        button.setTitleColor(UIColor.dd.color(hexValue: 0xF50045), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    lazy var mLeftButtonLine: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
}

extension SettleInResultVC {
    func _bindView() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            if self.status == .failed {
                self.mTipLabel.text = userModel.userRoleDetail.remark
            }
        })
        
        _ = self.mLeftButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            _ = DDAPI.shared.request("settled/clearInformation").subscribe(onSuccess: { _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
        })
        
        _ = self.mBottomButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            switch self.status {
            case .process:
                self.navigationController?.popToRootViewController(animated: true)
            case .success:
                //申请成功
                print("sssss")
            case .failed:
                //重新提交
                let model = DDUserTools.shared.userInfo.value.userRoleDetail
                let vc = SettleInVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}
