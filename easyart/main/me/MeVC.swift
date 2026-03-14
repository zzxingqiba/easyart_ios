//
//  MeVC.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit
import ZLPhotoBrowser
import SwiftyJSON
import SnapKit

class MeVC: BaseVC {
    var mbottomConstraint: Constraint?
    init() {
        super.init(bottomPadding: 50)
        
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (DDUserTools.shared.isLogin) {
            _ = DDUserTools.shared.updateUserInfo(getRoleInfo: true).subscribe(onSuccess: { isUpdate in
                print("更新成功")
            })
        }
        if !self.mArtworksView.isHidden {
            self.mArtworksView.reloadData()
        } else {
            self.mCollectionView.loadData()
        }
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(self.mImageView)
        self.mImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(60)
        }
        
        self.mSafeView.addSubview(mEditImageView)
        mEditImageView.snp.makeConstraints { make in
            make.top.right.equalTo(self.mImageView)
            make.width.equalTo(23)
            make.height.equalTo(14)
        }
        
        self.mSafeView.addSubview(mSettingButton)
        mSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(mMessageButton)
        mMessageButton.snp.makeConstraints { make in
            make.centerX.equalTo(mSettingButton)
            make.top.equalTo(mSettingButton.snp.bottom).offset(20)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(mMessageRedIcon)
        mMessageRedIcon.snp.makeConstraints { make in
            make.top.equalTo(mMessageButton).offset(-5)
            make.left.equalTo(mMessageButton.snp.right).offset(-3)
            make.width.height.equalTo(6)
        }
        
        //昵称
        self.mSafeView.addSubview(self.mNameTextField)
        self.mNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mImageView.snp.bottom).offset(0)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mArtistButton)
        mArtistButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mLoginButton)
        mLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(mFollowsNumberView)
        mFollowsNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(mArtistButton.snp.bottom).offset(20)
        }
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(leftLine)
        leftLine.snp.makeConstraints { make in
            make.right.equalTo(mFollowsNumberView.snp.left)
            make.centerY.equalTo(mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(mSaveNumberView)
        mSaveNumberView.snp.makeConstraints { make in
            make.right.equalTo(leftLine.snp.left)
            make.width.equalTo(mFollowsNumberView)
            make.top.equalTo(mFollowsNumberView)
        }
        
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(rightLine)
        rightLine.snp.makeConstraints { make in
            make.left.equalTo(mFollowsNumberView.snp.right)
            make.centerY.equalTo(mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(mOrderNumberView)
        mOrderNumberView.snp.makeConstraints { make in
            make.left.equalTo(rightLine.snp.right)
            make.width.equalTo(mFollowsNumberView)
            make.top.equalTo(mFollowsNumberView)
        }
        
        self.mSafeView.addSubview(mMeMenuTabView)
        mMeMenuTabView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mFollowsNumberView.snp.bottom).offset(30)
        }
        
        self.mSafeView.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mMeMenuTabView.snp.bottom).offset(20)
            self.mbottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        self.mSafeView.addSubview(mArtworksView)
        mArtworksView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(mMeMenuTabView.snp.bottom).offset(20)
        }
    }
    

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = ThemeColor.line.color()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var mEditImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = UIImage(named: "icon-edit-me")
        return imageView
    }()
    
    lazy var mNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Enter nickname".localString
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = ThemeColor.gray.color()
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var mArtistButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.attributedText = NSAttributedString(string: "Becoming an artist".localString, attributes: [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        return button
    }()
    
    lazy var mLoginButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.isHidden = true
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.text = "Log in".localString
        button.layer.borderColor = UIColor.dd.color(hexValue: 0xA39FAC).cgColor
        button.layer.borderWidth = 0.5
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var mSaveNumberView: MeNumberItemView = {
        let view = MeNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-save")
        view.mIconButton.mTitleLabel.text = "Save"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mFollowsNumberView: MeNumberItemView = {
        let view = MeNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-follows")
        view.mIconButton.mTitleLabel.text = "Follows"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mOrderNumberView: MeNumberItemView = {
        let view = MeNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-order")
        view.mIconButton.mTitleLabel.text = "Order"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mMessageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "me_message"), for: .normal)
        return button
    }()
    
    lazy var mMessageRedIcon: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .red
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var mSettingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "me-icon-setting"), for: .normal)
        return button
    }()
    
    lazy var mMeMenuTabView: MeMenuTabView = {
        let view = MeMenuTabView()
        return view
    }()
    
    lazy var mCollectionView: MeCollectionView = {
        let view = MeCollectionView()
        return view
    }()
    
    lazy var mArtworksView: MeArtworksView = {
        let view = MeArtworksView()
        view.isHidden = true
        return view
    }()
}

extension MeVC {
    func _bindView() {
        _ = self.mMeMenuTabView.indexChange.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.mbottomConstraint?.deactivate()
            self.mCollectionView.isHidden = index == 1
            self.mArtworksView.isHidden = index == 0
            if index == 0 {
                self.mCollectionView.snp.makeConstraints { make in
                    self.mbottomConstraint = make.bottom.equalToSuperview().constraint
                }
                self.mCollectionView.loadData()
            } else {
                self.mArtworksView.snp.makeConstraints { make in
                    self.mbottomConstraint = make.bottom.equalToSuperview().constraint
                }
                self.mArtworksView.reloadData()
            }
        })
        
        _ = DDUserTools.shared.userInfo.subscribe(onNext: { [weak self] userModel in
            guard let self = self else { return }
            self.mImageView.kf.setImage(with: URL(string: userModel.face_url))
            if DDUserTools.shared.isLogin {
                self.mNameTextField.isHidden = false
                if String.isAvailable(userModel.name) {
                    self.mNameTextField.text = userModel.name
                } else {
                    self.mNameTextField.text = nil
                }
                self.mNameTextField.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
//                self.mLoginButton.isHidden = true
//                self.mArtistButton.isHidden = false
            } else {
                self.mNameTextField.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.mNameTextField.isHidden = true
                
//                self.mLoginButton.isHidden = false
//                self.mArtistButton.isHidden = true
            }
            self.mSaveNumberView.mNumberLabel.text = String.isAvailable(userModel.collect_num) ? userModel.collect_num : "0"
            self.mSaveNumberView.mRedIcon.isHidden = !userModel.collect_new
            self.mFollowsNumberView.mNumberLabel.text = "\(userModel.follow_num)"
            self.mOrderNumberView.mNumberLabel.text = "\(userModel.order_num + userModel.sellout_num)"
            self.mOrderNumberView.mRedIcon.isHidden = !userModel.order_new && !userModel.sellout_new
            self.mMessageRedIcon.isHidden = !userModel.new_sys_msg && !userModel.new_follow_msg
            //小红点
            self.mSaveNumberView.mRedIcon.isHidden = !userModel.collect_new
            //入驻
            if userModel.role.user_role == 2 {
                self.mArtistButton.isHidden = true
                self.mLoginButton.isHidden = true
                self.mArtistButton.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self.mArtistButton.isHidden = !DDUserTools.shared.isLogin
                self.mLoginButton.isHidden = DDUserTools.shared.isLogin
                self.mArtistButton.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
            }
            self.mEditImageView.isHidden = !(userModel.role.user_role == 2 && DDUserTools.shared.userInfo.value.role.status == 1)
        })
        
        _ = self.mMessageButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = MessageListVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mSettingButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if DDUserTools.shared.isLogin {
                let vc = SettingVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                DDUserTools.shared.login()
            }
        })
        
        _ = self.mArtistButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if DDUserTools.shared.isLogin {
                self._becomeArtist()
            } else {
                DDUserTools.shared.login()
            }
        })
        
        _ = self.mLoginButton.rx.tap.subscribe(onNext: { _ in
            DDUserTools.shared.login()
        })
        
        _ = self.mSaveNumberView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DDCollectionListVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mFollowsNumberView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = DDFollowListVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        _ = self.mOrderNumberView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if DDUserTools.shared.userInfo.value.role.user_role == 1 {
                let vc = OrderListVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = OrderTypeListVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        //修改头像
        let avartTap = UITapGestureRecognizer()
        _ = avartTap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !DDUserTools.shared.isLogin {
                DDUserTools.shared.login()
                return
            }
            ZLPhotoConfiguration.default().allowSelectVideo = false
            ZLPhotoConfiguration.default().maxSelectCount = 1
            let ps = ZLPhotoPicker()
            ps.selectImageBlock = { results, isOriginal in
                // your code
                if let image = results.first?.image.pngData() {
                    _ = DDAPI.shared.upload("home/upFace", params: [:], data: image).subscribe(onNext: { response in
                        let json = JSON(response.data)
                        let user = DDUserTools.shared.userInfo.value
                        user.face_url = json["face_url"].stringValue
                        DDUserTools.shared.userInfo.accept(user)
                    })
                }
            }
            ps.showPhotoLibrary(sender: self)
        })
        self.mImageView.addGestureRecognizer(avartTap)
        
        //昵称
        _ = self.mNameTextField.rx.controlEvent([.editingDidEndOnExit, .editingDidEnd]).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !DDUserTools.shared.isLogin {
                DDUserTools.shared.login()
                return
            }
            //修改昵称
            if String.isAvailable(self.mNameTextField.text) {
                _ = DDAPI.shared.request("home/upUser", data: ["nickName": self.mNameTextField.text!]).subscribe(onSuccess: { response in
                    let user = DDUserTools.shared.userInfo.value
                    user.name = self.mNameTextField.text!
                    DDUserTools.shared.userInfo.accept(user)
                })
            } else {
                
            }
        })
        
        _ = self.mArtworksView.becomeArtistClick.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if DDUserTools.shared.isLogin {
                self._becomeArtist()
            } else {
                DDUserTools.shared.login()
            }
        })
    }
    
    func _becomeArtist() {
        let userModel = DDUserTools.shared.userInfo.value
        if (userModel.role.user_role == 1) {
            let vc = SettleInVC(bottomPadding: 100)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //status: 1正常，2:删除，3:等待基础审核，4:基础审核通过，5:基础审核拒绝 6等待详细审核 7详细审核拒绝  8拉黑  9修改
            if userModel.role.status == 6 {
                let vc = SettleInResultVC()
                vc.status = SettleInResultStatus.process
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if userModel.role.status == 7 {
                let vc = SettleInResultVC()
                vc.status = SettleInResultStatus.failed
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension MeVC {
    //MARK: UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        if index == 0 {
//            
//        } else if index == 1 {
//            
//        } else if index == 2 {
//            
//        } else if index == 3 {
//            let vc = AddressManageVC()
//            vc.isAutoBack = false
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if index == 4 {
//            
//            
//        } else if index == 5 {
//            
//        } else if index == 6 {
//            let vc = QLWebViewController(url: URL(string: "https://www.easyartonline.com/agreement")!)
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else if index == 7 {
//           
//            
//        }
//    }
}
