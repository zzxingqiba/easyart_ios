//
//  SearchOrgView.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class SearchOrgView: DDView {
    let clickPublish = PublishRelay<DDOrgModel>()
    private var pageCur = 1
    private var hasMore = true
    var name = "" {
        didSet {
            self.reloadData()
        }
    }
    var list = [DDOrgModel]()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
        
        //更新数据
        self._bindView()
        self.loadData()
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
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(SearchOrgTableViewCell.self, forCellReuseIdentifier: "SearchOrgTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

}

extension SearchOrgView {
    func reloadData() {
        self.pageCur = 1
        self.loadData()
    }
    
    func loadData() {
        _ = DDAPI.shared.request("search/instituteList", data: ["page_find": self.pageCur, "name": self.name]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = (data["institute_list"].arrayObject as? [[String: Any]]) ?? []
            let list =  goodsList.kj.modelArray(DDOrgModel.self)
            if (self.pageCur == 1) {
                self.list = list
            } else {
                self.list.append(contentsOf: list)
            }
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

extension SearchOrgView {
    func _bindView() {
        self.mTableView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self.loadData()
        }
        self.mTableView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self.loadData()
            } else {
                self.mTableView.mj_footer?.endRefreshing()
            }
        }
    }
}

extension SearchOrgView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchOrgTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchOrgTableViewCell") as! SearchOrgTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.row]
        cell.updateUI(model: model)
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
        let model = self.list[indexPath.row]
        self.clickPublish.accept(model)
    }
}
