//
//  OrderListVC.swift
//  easyart
//
//  Created by Damon on 2024/9/24.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils
import HDHUD

enum OrderListType {
    case buy    //买入
    case sell   //卖出
}

class OrderListVC: BaseVC {
    var orderListType: OrderListType = .buy
    private var pageCur = 1
    private var hasMore = true
    private var list = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        if self.orderListType == .buy {
            self.mTabView.updateUI(titleList: ["Total".localString, "Transaction".localString, "Pending".localString, "Delivered".localString])
        } else {
            self.mTabView.updateUI(titleList: ["Total".localString, "Transaction".localString, "Pending".localString, "Delivered".localString])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageCur = 1
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        
        self.mSafeView.addSubview(mTabView)
        mTabView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mTabView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mEmptyImageView)
        mEmptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mTabView.snp.bottom).offset(70)
            make.width.equalTo(70)
            make.height.equalTo(38)
        }
    }
    
    //MARK: UI
    lazy var mTabView: DDOrderTypeTabView = {
        let view = DDOrderTypeTabView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        return view
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
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDOrderTableViewCell.self, forCellReuseIdentifier: "DDOrderTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()
    
    lazy var mEmptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_noData"))
        return imageView
    }()
}

extension OrderListVC {
    func _bindView() {
        self.mTableView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self._loadData()
        }
        self.mTableView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self._loadData()
            } else {
                self.mTableView.mj_footer?.endRefreshing()
            }
        }
        
        //切换订单
        _ = self.mTabView.indexChange.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.pageCur = 1
            self._loadData()
        })
    }
    
    func _loadData() {
        var url = "goods/orderList"
        var data = ["page_find": self.pageCur, "find_status": self.mTabView.selectedIndex]
        if self.orderListType == .sell {
            url = "logistics/logisticsList"
            data = ["page_find": self.pageCur, "status": self.mTabView.selectedIndex]
        }
        //1:待支付, 2:进行中, 3:已结束
        _ = DDAPI.shared.request(url, data: data).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let orderList = data["order_list"].arrayValue
            if (self.pageCur == 1) {
                self.list = orderList
            } else {
                self.list.append(contentsOf: orderList)
            }
            self.mEmptyImageView.isHidden = !self.list.isEmpty
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            self.mTableView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
        })
    }
}

extension OrderListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DDOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DDOrderTableViewCell") as! DDOrderTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.section]
        cell.clickPublish.subscribe(onNext: { [weak self] tag in
            guard let self = self else { return }
            if tag == .contact {
                UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
            } else if tag == .pay {
                StripeTools.shared.resultPublish.subscribe(onNext: { [weak self] result in
                    self?.pageCur = 1
                    self?._loadData()
                }).disposed(by: StripeTools.shared.disposeBag)
                StripeTools.shared.startPay(orderID: model["order_id"].stringValue)
            } else if tag == .cancel {
                let sheet = DDSheetView()
                sheet.mTitleLabel.text = "Do you want to cancel the order".localString
                _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                    guard let self = self else { return }
                    DDPopView.hide()
                    if buttonType == .confirm {
                        _ = DDAPI.shared.request("goods/orderCancel", data: ["order_id": model["order_id"].stringValue]).subscribe(onSuccess: { [weak self] response in
                            HDHUD.show("Cancelled successfully".localString)
                            self?.pageCur = 1
                            self?._loadData()
                        })
                    }
                })
                DDPopView.show(view: sheet, animationType: .bottom)
            } else if tag == .delete {
                let sheet = DDSheetView()
                sheet.mTitleLabel.text = "Do you want to delete the order".localString
                _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                    guard let self = self else { return }
                    DDPopView.hide()
                    if buttonType == .confirm {
                        _ = DDAPI.shared.request("goods/orderDel", data: ["order_id": model["order_id"].stringValue]).subscribe(onSuccess: { [weak self] response in
                            HDHUD.show("Delete successful".localString)
                            self?.pageCur = 1
                            self?._loadData()
                        })
                    }
                })
                DDPopView.show(view: sheet, animationType: .bottom)
            }  else if tag == .recieve {
                let sheet = DDSheetView()
                sheet.mTitleLabel.text = "Confirm receipt".localString
                _ = sheet.mClickSubject.subscribe(onNext: { [weak self] buttonType in
                    guard let self = self else { return }
                    DDPopView.hide()
                    if buttonType == .confirm {
                        _ = DDAPI.shared.request("goods/orderRecv", data: ["order_id": model["order_id"].stringValue]).subscribe(onSuccess: { [weak self] response in
                            HDHUD.show("Goods received successfully".localString, icon: .success)
                            self?.pageCur = 1
                            self?._loadData()
                        })
                    }
                })
                DDPopView.show(view: sheet, animationType: .bottom)
            } else if tag == .send {
                let vc = OrderSendVC(orderNumber: model["order_number"].stringValue)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: cell.disposeBag)
        cell.updateUI(model: model, orderListType: self.orderListType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 10
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
        let vc = OrderDetailVC(orderID: model["order_id"].stringValue)
        vc.orderListType = self.orderListType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
