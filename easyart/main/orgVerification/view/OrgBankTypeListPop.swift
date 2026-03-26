//
//  OrgBankTypeListPop.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/25.
//

import DDUtils
import RxRelay
import UIKit

class OrgBankTypeListPop: DDView {
    let clickPublish = PublishRelay<DDPopButtonClickInfo>()

    var list = [OrgBankInfoType]()
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo(500)
        }

        self.addSubview(self.mTitleLabel)
        self.mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        self.addSubview(self.mCloseButton)
        self.mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(self.mTitleLabel)
            make.width.height.equalTo(30)
        }

        self.addSubview(self.mTableView)
        self.mTableView.snp.makeConstraints { make in
            make.top.equalTo(self.mTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-BottomSafeAreaHeight)
        }

        self._bindView()
    }

    // MARK: UI

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()

    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .singleLine
        tTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tTableView.separatorColor = UIColor.dd.color(hexValue: 0xe6e6e6)
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDAddressCountryTableViewCell.self, forCellReuseIdentifier: "DDAddressCountryTableViewCell")
        return tTableView
    }()

    lazy var mCloseButton: DDButton = {
        let button = DDButton()
        button.normalImage = UIImage(named: "home_guanbi")
        button.imageSize = CGSizeMake(16, 16)
        return button
    }()

    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Confirm".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()
}

extension OrgBankTypeListPop {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(.init(clickType: .close, info: nil))
        })
    }
}

extension OrgBankTypeListPop: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DDAddressCountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DDAddressCountryTableViewCell") as! DDAddressCountryTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.row]
        cell.updateUI(title: model.name)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.list[indexPath.row]
        self.clickPublish.accept(DDPopButtonClickInfo(clickType: .confirm, info: model))
    }
}
