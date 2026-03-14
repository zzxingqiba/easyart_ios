//
//  OrderTypeListVC.swift
//  easyart
//
//  Created by Damon on 2025/6/24.
//

import UIKit

class OrderTypeListVC: BaseVC {
    private let list = [MeSettingModel(title: "Order".localString, des: "\(DDUserTools.shared.userInfo.value.order_num)"), MeSettingModel(title: "Sell".localString, des: "\(DDUserTools.shared.userInfo.value.sellout_num)")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = DDUserTools.shared.updateUserInfo().subscribe(onSuccess: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.reloadData()
        })
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
        tTableView.register(DDOrderTypeListCell.self, forCellReuseIdentifier: "DDOrderTypeListCell")
        return tTableView
    }()

}

extension OrderTypeListVC {
    func _bindView() {
        _ = mTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
            self.mTableView.snp.updateConstraints { (make) in
                make.height.equalTo(contentSize.height)
            }
        })
    }
}

extension OrderTypeListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DDOrderTypeListCell = tableView.dequeueReusableCell(withIdentifier: "DDOrderTypeListCell") as! DDOrderTypeListCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.row]
        cell.updateUI(model: model)
        if indexPath.row == 0 {
            cell.mRedIconView.isHidden = !DDUserTools.shared.userInfo.value.order_new
        } else if indexPath.row == 1 {
            cell.mRedIconView.isHidden = !DDUserTools.shared.userInfo.value.sellout_new
        }
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
            //买入订单
            let vc = OrderListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if index == 1 {
            let vc = OrderListVC()
            vc.orderListType = .sell
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
