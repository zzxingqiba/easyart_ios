//
//  AddressManageVC.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import KakaJSON
import MJRefresh
import SwiftyJSON
import RxRelay

class AddressManageVC: BaseVC {
    var list = [DDAddressModel]()
    var isAutoBack = true
    var selectedModel: DDAddressModel?
    let addressChangeRelay = PublishRelay<DDAddressModel?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addressChangeRelay.accept(self.selectedModel)
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mTableView)
        self.mSafeView.ignoreSafeAreaType = .bottom
        mTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mAddButton)
        mAddButton.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
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
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(AddressTableViewCell.self, forCellReuseIdentifier: "AddressTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()
    
    lazy var mAddButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "+ " + "Add shipping address".localString
        button.mTitleLabel.font = .systemFont(ofSize: 15)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()

}

private extension AddressManageVC {
    func _bindView() {
        self.mTableView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self._loadData()
        }
        
        _ = self.mAddButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = AddressEditVC()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    func _loadData() {
        _ = DDAPI.shared.request("home/addrList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = (data["addr_list"].arrayObject as? [[String: Any]]) ?? []
            self.list =  goodsList.kj.modelArray(DDAddressModel.self)
            //更新最新数据
            if self.list.count == 1 {
                self.selectedModel = self.list.first
            } else if let selectedModel = self.selectedModel {
                for item in self.list {
                    if item.id == selectedModel.id {
                        self.selectedModel = item
                        break
                    }
                }
            }
            self.mTableView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
        })
    }
}

extension AddressManageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.section]
        cell.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = AddressEditVC()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        cell.updateUI(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = self.list[indexPath.section]
        if let selectedModel = self.selectedModel, model.id == selectedModel.id {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
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
        let model = self.list[indexPath.section]
        self.selectedModel = model
        if (isAutoBack) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
