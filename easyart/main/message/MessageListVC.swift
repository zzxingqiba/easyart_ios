//
//  MessageListVC.swift
//  easyart
//
//  Created by Damon on 2025/6/18.
//

import UIKit
import KakaJSON
import SwiftyJSON

class MessageListVC: BaseVC {
    private var selectedIndex = 0 {
        didSet {
            self.mFollowTableView.isHidden = selectedIndex == 1
            self.mNotificationTableView.isHidden = selectedIndex == 0
        }
    }
    private var pageFind = 1
    private var mFollowMessageList = [FollowMessageModel]()
    private var mNotificationList = [MessageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._bindView()
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        self.mSafeView.addSubview(mMessageTypeTabView)
        mMessageTypeTabView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.mSafeView.addSubview(mFollowTableView)
        mFollowTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mMessageTypeTabView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.mSafeView.addSubview(mNotificationTableView)
        mNotificationTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(mMessageTypeTabView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.mSafeView.addSubview(mEmptyImageView)
        mEmptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(70)
            make.height.equalTo(38)
        }
    }
    

    //MARK: UI
    lazy var mMessageTypeTabView: MessageTypeTabView = {
        let view = MessageTypeTabView()
        view.selectedIndex = 0
        return view
    }()
    
    lazy var mFollowTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.tag = 1
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(MessageFollowTableViewCell.self, forCellReuseIdentifier: "MessageFollowTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()
    
    lazy var mNotificationTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.isHidden = true
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.tag = 2
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(MessageNotificationTableViewCell.self, forCellReuseIdentifier: "MessageNotificationTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

    lazy var mEmptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_noData"))
        return imageView
    }()
}

extension MessageListVC {
    func _bindView() {
        _ = self.mMessageTypeTabView.indexChange.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.selectedIndex = index
            self.pageFind = 1
            self._loadData()
        })
    }
    
    func _loadData() {
        if self.selectedIndex == 0 {
            self._loadFollowList()
        } else {
            self._loadMessageList()
        }
    }
    
    func _loadFollowList() {
        self.mEmptyImageView.isHidden = !self.mFollowMessageList.isEmpty
        _ = DDAPI.shared.request("system/followList", data: ["page_find": self.pageFind]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            if let messageList = data["msg_list"].arrayObject as? [[String: Any]] {
                let list = messageList.kj.modelArray(FollowMessageModel.self)
                if (self.pageFind == 1) {
                    self.mFollowMessageList = list
                } else {
                    self.mFollowMessageList.append(contentsOf: list)
                }
                self.mEmptyImageView.isHidden = !self.mFollowMessageList.isEmpty
                self.mFollowTableView.reloadData()
            }
        })
    }
    
    func _loadMessageList() {
        self.mEmptyImageView.isHidden = !self.mNotificationList.isEmpty
        _ = DDAPI.shared.request("system/MsgList", data: ["page_find": self.pageFind]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            if let messageList = data["msg_list"].arrayObject as? [[String: Any]] {
                let list = messageList.kj.modelArray(MessageModel.self)
                if (self.pageFind == 1) {
                    self.mNotificationList = list
                } else {
                    self.mNotificationList.append(contentsOf: list)
                }
                self.mEmptyImageView.isHidden = !self.mNotificationList.isEmpty
                self.mNotificationTableView.reloadData()
            }
        })
    }
}

extension MessageListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.selectedIndex == 0 ? self.mFollowMessageList.count : self.mNotificationList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedIndex == 0 && tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageFollowTableViewCell") as! MessageFollowTableViewCell
            let model = self.mFollowMessageList[indexPath.section]
            cell.selectionStyle = .none
            cell.updateUI(model: model)
            return cell
        } else if self.selectedIndex == 1 && tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageNotificationTableViewCell") as! MessageNotificationTableViewCell
            let model = self.mNotificationList[indexPath.section]
            cell.selectionStyle = .none
            cell.updateUI(model: model)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndex == 0 {
            let model = self.mFollowMessageList[indexPath.section]
            let vc = DDAuthorDetailVC(id: model.artist_id)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            //标记已读
            _ = DDAPI.shared.request("system/followRead", data: ["id": model.id]).subscribe(onSuccess: { _ in
                model.is_read = true
                tableView.reloadData()
            })
        } else {
            let model = self.mNotificationList[indexPath.section]
            //标记已读
            _ = DDAPI.shared.request("system/checkMsg", data: ["id": model.id]).subscribe(onSuccess: { _ in
                model.is_read = true
                tableView.reloadData()
            })
            //跳转
            if model.url_type == 1 {
                //订单详情
                let vc = OrderDetailVC(orderID: model.url_param.order_id)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if model.url_type == 2 {
                //跳转客服
                UIApplication.shared.open(URL(string: "mailto:info@easyart.cn")!)
            } else if model.url_type == 4 {
                //点击跳转机构主页
            } else if model.url_type == 5 {
                //跳转作品详情
                let vc = DetailVC(goodsID: model.url_param.goods_id)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if model.url_type == 3 || model.url_type == 6 {
                //跳转作家详情页
                let vc = DDAuthorDetailVC(id: model.url_param.role_id)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if model.url_type == 7 {
                //卖家订单详情
                let vc = OrderDetailVC(orderID: model.url_param.order_id)
                vc.orderListType = .sell
                self.navigationController?.pushViewController(vc, animated: true)
            } else if model.url_type == 8 {
                //TODO: 审核结果页
                
            }
        }
    }
}
