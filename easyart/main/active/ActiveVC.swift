//
//  ActiveVC.swift
//  easyart
//
//  Created by Damon on 2024/10/28.
//

import UIKit
import SwiftyJSON
import MJRefresh
import DDUtils

class ActiveVC: BaseVC {
    private var pageCur = 1
    private var hasMore = true
    var list = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBarTitle(title: "Art Project".localString, textColor: ThemeColor.black.color())
        self.loadData()
        self._bindView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DDUtils.shared.requestIDFAPermission { status in
                print("status", status)
            }
        }
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.ignoreSafeAreaType = .bottom
        self.mSafeView.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
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
        tTableView.register(ActiveTableViewCell.self, forCellReuseIdentifier: "ActiveTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

}

extension ActiveVC {
    func reloadData() {
        self.pageCur = 1
        self.loadData()
    }
    
    func loadData() {
        _ = DDAPI.shared.request("match/matchListV2", data: ["page_find": self.pageCur]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let list =  data.arrayValue
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

extension ActiveVC {
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

extension ActiveVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActiveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ActiveTableViewCell") as! ActiveTableViewCell
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
        let jumpType = model["jump_type"].intValue
        if jumpType == 2 {
            let url = model["jump_url"].stringValue
            let vc = QLWebViewController(url: URL(string: url)!)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
