//
//  SettingVC.swift
//  easyart
//
//  Created by Damon on 2024/10/12.
//

import UIKit
import DDUtils
import SwiftyJSON
import RxRelay
import HDHUD

import DDLoggerSwift
import DDKitSwift


class SettingVC: BaseVC {
    var list: [MeSettingModel] {
        var settingList = [MeSettingModel(title: "Address".localString), MeSettingModel(title: "Profile".localString), MeSettingModel(title: "Contact".localString), MeSettingModel(title: "Log out".localString), MeSettingModel(title: "Delete my account".localString)]
        if APP_DEBUG {
            settingList.append(MeSettingModel(title: "调试信息".localString))
        }
        return settingList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.contentType = .flex
        
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
    }

    //MARK: UI
    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .singleLine
        tTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tTableView.separatorColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.isScrollEnabled = false
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(MeSettingTableViewCell.self, forCellReuseIdentifier: "MeSettingTableViewCell")
        return tTableView
    }()

}

extension SettingVC {
    func _bindView() {
        _ = mTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mTableView.snp.updateConstraints { (make) in
                make.height.equalTo(contentSize.height)
            }
        })
    }
    
    func _deleteAccount() {
        let warn = DDWarnPopView(title: "Delete account".localString, content: "After deleting the account, all information will be cleared. Please proceed with caution".localString)
        warn.mFirstButton.setTitle("Confirm".localString, for: .normal)
        _ = warn.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
            DDPopView.hide()
            guard let self = self else { return }
            if (clickInfo.clickType == .confirm) {
                if DDUserTools.shared.userInfo.value.app_type == .apple {
                    //苹果用户
                    self._deleteAppleUser()
                } else {
                    self._deleteOther()
                }
            }
        })
        DDPopView.show(view: warn)
    }
    
    func _deleteAppleUser() {
        let warn = DDAppleAuthorPop()
        warn.mTitleLabel.text = "Delete account".localString
        warn.mContentLabel.text = "Click the button to authorize and start deleting the account".localString
        _ = warn.mClickSubject.subscribe(onNext: { clickInfo in
            DDPopView.hide()
            if clickInfo.clickType == .confirm, let token = clickInfo.info as? String {
                _ = DDAPI.shared.request("home/logOff", data: ["id_token": token]).subscribe(onSuccess: { response in
                    DDUserTools.shared.logout()
                    DDUtils.shared.getCurrentVC()?.navigationController?.popToRootViewController(animated: true)
                })
            }
        })
        DDPopView.show(view: warn)
    }
    
    func _deleteOther() {
        _ = DDAPI.shared.request("home/logOff").subscribe(onSuccess: { response in
            DDUserTools.shared.logout()
            DDUtils.shared.getCurrentVC()?.navigationController?.popToRootViewController(animated: true)
        })
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MeSettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MeSettingTableViewCell") as! MeSettingTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.row]
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            let vc = AddressManageVC()
            vc.isAutoBack = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else if index == 1 {
            let vc = SettleInVC(isEdit: true)
            vc.isPreviewMode = true
            let userModel = DDUserTools.shared.userInfo.value
            vc.profileModel.update(model: userModel.userRoleDetail)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if index == 2 {
            UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
        } else if index == 3 {
            let warn = DDWarnPopView(title: "Log out".localString, content: "Log out".localString)
            warn.mFirstButton.setTitle("Confirm".localString, for: .normal)
            _ = warn.mClickSubject.subscribe(onNext: { [weak self] clickInfo in
                DDPopView.hide()
                guard let self = self else { return }
                if (clickInfo.clickType == .confirm) {
                    DDUserTools.shared.logout()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            DDPopView.show(view: warn)
        } else if index == 4 {
            self._deleteAccount()
        } else if index == 5 {
            DDKitSwift.show()
        }
    }
}
