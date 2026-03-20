//
//  MineVC.swift
//  easyart
//
//  Created by 喵小呆 on 2026/3/14.
//
import SnapKit
import SwiftyJSON
import UIKit
import ZLPhotoBrowser

class MineVC: BaseVC {
    var mbottomConstraint: Constraint?
    init() {
        super.init(bottomPadding: 50)
    }
    
    @available(*, unavailable)
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
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
        
        self.mSafeView.addSubview(self.mEditImageView)
        self.mEditImageView.snp.makeConstraints { make in
            make.top.right.equalTo(self.mImageView)
            make.width.equalTo(23)
            make.height.equalTo(14)
        }
        
        self.mSafeView.addSubview(self.mSettingButton)
        self.mSettingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(self.mMessageButton)
        self.mMessageButton.snp.makeConstraints { make in
            make.top.equalTo(self.mSettingButton.snp.bottom).offset(20)
            make.centerX.equalTo(self.mSettingButton)
            make.width.height.equalTo(20)
        }
        
        self.mSafeView.addSubview(self.mMessageRedIcon)
        self.mMessageRedIcon.snp.makeConstraints { make in
            make.top.equalTo(self.mMessageButton).offset(-5)
            make.left.equalTo(self.mMessageButton.snp.right).offset(-3)
            make.width.height.equalTo(6)
        }
        
        self.mSafeView.addSubview(self.mNameTextField)
        self.mNameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mImageView.snp.bottom).offset(0)
            make.height.equalTo(30)
        }
        
        // 入驻平台/艺术家
        self.mSafeView.addSubview(self.mBecomeButton)
        self.mBecomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(self.mLoginButton)
        self.mLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mNameTextField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.mSafeView.addSubview(self.mFollowsNumberView)
        self.mFollowsNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(self.mBecomeButton.snp.bottom).offset(20)
        }
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(leftLine)
        leftLine.snp.makeConstraints { make in
            make.right.equalTo(self.mFollowsNumberView.snp.left)
            make.centerY.equalTo(self.mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(self.mSaveNumberView)
        self.mSaveNumberView.snp.makeConstraints { make in
            make.right.equalTo(leftLine.snp.left)
            make.width.equalTo(self.mFollowsNumberView)
            make.top.equalTo(self.mFollowsNumberView)
        }
        
        let rightLine = UIView()
        leftLine.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        self.mSafeView.addSubview(rightLine)
        rightLine.snp.makeConstraints { make in
            make.left.equalTo(self.mFollowsNumberView.snp.right)
            make.centerY.equalTo(self.mFollowsNumberView)
            make.width.equalTo(1.5)
            make.height.equalTo(7.5)
        }
        
        self.mSafeView.addSubview(self.mOrderNumberView)
        self.mOrderNumberView.snp.makeConstraints { make in
            make.left.equalTo(rightLine.snp.right)
            make.width.equalTo(self.mFollowsNumberView)
            make.top.equalTo(self.mFollowsNumberView)
        }
        
        // Tab
        self.mSafeView.addSubview(self.mMineMenuTabView)
        self.mMineMenuTabView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mFollowsNumberView.snp.bottom).offset(20)
        }
        // Collection
        self.mSafeView.addSubview(self.mCollectionView)
        self.mCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mMineMenuTabView.snp.bottom).offset(20)
        }
        // Art or Org
        self.mSafeView.addSubview(self.mArtorOrgView)
        self.mArtorOrgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mMineMenuTabView.snp.bottom).offset(20)
        }
    }
    
    // MARK: UI
    lazy var mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
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
    
    lazy var mSettingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "me-icon-setting"), for: .normal)
        return button
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
    
    lazy var mNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Enter nickname".localString
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = ThemeColor.gray.color()
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var mBecomeButton: DDButtonFixed = {
        let button = DDButtonFixed(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), gap: 0)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.mTitleLabel.attributedText = NSAttributedString(string: "Join the platform".localString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: ThemeColor.black.color()])
        button.mTitleLabel.font = .systemFont(ofSize: 12)
        return button
    }()
    
    lazy var mLoginButton: DDButtonFixed = {
        let button = DDButtonFixed(imagePosition: .none)
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
    
    lazy var mSaveNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-save")
        view.mIconButton.mTitleLabel.text = "Save"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mFollowsNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-follows")
        view.mIconButton.mTitleLabel.text = "Follows"
        view.mNumberLabel.text = "0"
        return view
    }()
    
    lazy var mOrderNumberView: MineNumberItemView = {
        let view = MineNumberItemView()
        view.mIconButton.normalImage = UIImage(named: "me-icon-order")
        view.mIconButton.mTitleLabel.text = "Order"
        view.mNumberLabel.text = "0"
        return view
    }()

    lazy var mMineMenuTabView: MineMenuTabView = .init()
    
    lazy var mCollectionView: MineCollectionView = .init()

    lazy var mArtorOrgView: MineArtorOrgView = {
        let view = MineArtorOrgView()
        view.isHidden = true
        return view
    }()
}

extension MineVC {
    func _bindView() {
        _ = self.mMineMenuTabView.indexChange.subscribe(onNext: {
            [weak self] index in
            guard let self = self else { return }
            self.mbottomConstraint?.deactivate()
            self.mCollectionView.isHidden = index == 1
            self.mArtorOrgView.isHidden = index == 0
            if index == 0 {
                self.mCollectionView.loadData()
            } else {
                self.mArtorOrgView.reloadData()
            }
        })
        _ = DDUserTools.shared.userInfo.subscribe(onNext: {
            [weak self] userModel in
            guard let self = self else { return }
            print(userModel, "userModel")
            self.mImageView.kf.setImage(with: URL(string: userModel.face_url))
            self.mEditImageView.isHidden = !(([2, 3].contains(userModel.role.user_role)) && DDUserTools.shared.userInfo.value.role.status == 1)
            if DDUserTools.shared.isLogin {
                self.mLoginButton.isHidden = true
                self.mLoginButton.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.mNameTextField.isHidden = false
                if String.isAvailable(userModel.name) {
                    self.mNameTextField.text = userModel.name
                } else {
                    self.mNameTextField.text = nil
                }
                self.mNameTextField.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
            } else {
                self.mLoginButton.isHidden = false
                self.mLoginButton.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
                
                self.mNameTextField.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.mNameTextField.isHidden = true
            }
            
            self.mSaveNumberView.mNumberLabel.text = String.isAvailable(userModel.collect_num) ? userModel.collect_num : "0"
            self.mSaveNumberView.mRedIcon.isHidden = !userModel.collect_new
            
            self.mFollowsNumberView.mNumberLabel.text = "\(userModel.follow_num)"
//            self.mFollowsNumberView.mRedIcon.isHidden = !userModel.new_follow_msg
            
            self.mOrderNumberView.mNumberLabel.text = "\(userModel.order_num + userModel.sellout_num)"
            self.mOrderNumberView.mRedIcon.isHidden = !userModel.order_new && !userModel.sellout_new
            
            self.mMessageRedIcon.isHidden = !userModel.new_sys_msg && !userModel.new_follow_msg
            
            if [2, 3].contains(userModel.role.user_role) {
                self.mBecomeButton.isHidden = true
                self.mBecomeButton.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            } else {
                self.mBecomeButton.isHidden = !DDUserTools.shared.isLogin
                self.mBecomeButton.snp.updateConstraints { make in
                    make.height.equalTo(30)
                }
            }
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
        
        // 跳转入驻平台
        _ = self.mBecomeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if DDUserTools.shared.isLogin {
                // self._becomeArtist()
            } else {
                DDUserTools.shared.login()
            }
        })
        
        // 登陆
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
        
        // 修改头像
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
            ps.selectImageBlock = { results, _ in
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
        
        // 昵称
        _ = self.mNameTextField.rx.controlEvent([.editingDidEndOnExit, .editingDidEnd]).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if !DDUserTools.shared.isLogin {
                DDUserTools.shared.login()
                return
            }
            // 修改昵称
            if String.isAvailable(self.mNameTextField.text) {
                _ = DDAPI.shared.request("home/upUser", data: ["nickName": self.mNameTextField.text!]).subscribe(onSuccess: { _ in
                    let user = DDUserTools.shared.userInfo.value
                    user.name = self.mNameTextField.text!
                    DDUserTools.shared.userInfo.accept(user)
                })
            }
        })
        
        _ = self.mArtorOrgView.joinPlatformClick.subscribe(onNext: { [weak self] _ in
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
