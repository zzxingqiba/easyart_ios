//
//  HomeGoodsSortTypePop.swift
//  easyart
//
//  Created by Damon on 2025/6/19.
//

import UIKit
import RxRelay
import DDUtils

struct HomeGoodsSortType {
    var id: Int
    var title: String
}

class HomeGoodsSortTypePop: DDView {
    
    private let sortTypeList = [HomeGoodsSortType(id: 0, title: "Recommended".localString), HomeGoodsSortType(id: 1, title: "Artwork Price (Low)".localString), HomeGoodsSortType(id: 2, title: "Artwork Price (High)".localString), HomeGoodsSortType(id: 3, title: "Artwork Year (Descending)".localString), HomeGoodsSortType(id: 4, title: "Artwork Year (Ascending)".localString), HomeGoodsSortType(id: 5, title: "Recently Updated".localString)]
    let clickPublish = PublishRelay<HomeGoodsSortType>()
    var selectedID: Int = 0
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = ThemeColor.white.color()
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalToSuperview().offset(30)
        }
        
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.top.equalTo(mTitleLabel.snp.bottom).offset(40)
            make.height.equalTo(360)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        mTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort".localString
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = ThemeColor.black.color()
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
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(HomeGoodsSortTypePopTableViewCell.self, forCellReuseIdentifier: "HomeGoodsSortTypePopTableViewCell")
        tTableView.rowHeight = 60
        tTableView.isScrollEnabled = false
        return tTableView
    }()

}

extension HomeGoodsSortTypePop: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortTypeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeGoodsSortTypePopTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeGoodsSortTypePopTableViewCell") as! HomeGoodsSortTypePopTableViewCell
        cell.selectionStyle = .none
        let model = self.sortTypeList[indexPath.row]
        cell.updateUI(model: model)
        if (model.id == self.selectedID) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
        let model = self.sortTypeList[indexPath.row]
        self.clickPublish.accept(model)
    }
}

