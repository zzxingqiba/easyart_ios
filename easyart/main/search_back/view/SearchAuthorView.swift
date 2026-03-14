//
//  SearchAuthorView.swift
//  easyart
//
//  Created by Damon on 2024/10/24.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class SearchAuthorView: DDView {
    let clickPublish = PublishRelay<DDSearchAuthorModel>()
    var name = "" {
        didSet {
            self.reloadData()
        }
    }
    var list = [DDSearchAuthorListModel]()
    var nameList = [String]()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
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
        tTableView.separatorStyle = .none
//        tTableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 5)
//        tTableView.separatorColor = UIColor.dd.color(hexValue: 0xE6E6E6)
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(SearchAuthorTableViewCell.self, forCellReuseIdentifier: "SearchAuthorTableViewCell")
        tTableView.rowHeight = 54
        return tTableView
    }()

    
}

extension SearchAuthorView {
    func reloadData() {
        self.loadData()
    }
    
    func loadData() {
        _ = DDAPI.shared.request("search/getArtistList", data: ["keyword": self.name]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            guard let rList = response.data as? [[String: Any]] else { return }
            self.list = rList.kj.modelArray(DDSearchAuthorListModel.self)
            self.nameList = self.list.map({ model in
                return model.name
            })
            self.mTableView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
        })
    }
}

extension SearchAuthorView {
    func _bindView() {
        self.mTableView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.loadData()
        }
    }
}

extension SearchAuthorView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let modelList = self.list[section]
        return modelList.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAuthorTableViewCell") as! SearchAuthorTableViewCell
        cell.selectionStyle = .none
        let modelList = self.list[indexPath.section]
        let model = modelList.list[indexPath.row]
        cell.updateUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let modelList = self.list[section]
        let view = UIView()
        view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        let label = UILabel()
        label.text = modelList.name
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.lightGray.color()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        return view
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.nameList
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        var tpIndex:Int = 0
        //遍历索引值
        for character in self.nameList{
        //判断索引值和组名称相等，返回组坐标
            if character == title{
                return tpIndex
            }
            tpIndex += 1
        }
        return 0
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
        let modelList = self.list[indexPath.section]
        let model = modelList.list[indexPath.row]
        self.clickPublish.accept(model)
    }
}
