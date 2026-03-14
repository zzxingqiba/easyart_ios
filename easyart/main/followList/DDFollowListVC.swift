//
//  DDFollowListVC.swift
//  easyart
//
//  Created by Damon on 2024/12/3.
//

import UIKit
import SwiftyJSON

class DDFollowListVC: BaseVC {
    private var list: [JSON] = []
    private var pageCur = 1
    private var hasMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._loadData()
        self._bindView()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-17)
            make.bottom.equalToSuperview()
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
    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDFollowListTableViewCell.self, forCellReuseIdentifier: "DDFollowListTableViewCell")
        tTableView.rowHeight = 70
        return tTableView
    }()
    
    lazy var mEmptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_noData"))
        return imageView
    }()

}

extension DDFollowListVC {
    func _loadData() {
        _ = DDAPI.shared.request("settled/collectList", data: ["page_find": self.pageCur]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let list = data["artist_list"].arrayValue
            if (self.pageCur == 1) {
                self.list = list
            } else {
                self.list.append(contentsOf: list)
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
    
    func _bindView()  {
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
    }
}

extension DDFollowListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDFollowListTableViewCell") as! DDFollowListTableViewCell
        let model = list[indexPath.row]
        cell.selectionStyle = .none
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        let model = list[indexPath.row]
        let vc = DDAuthorDetailVC(id: model["artist_id"].stringValue)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
