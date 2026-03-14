//
//  SKUListView.swift
//  easyart
//
//  Created by Damon on 2024/11/15.
//

import UIKit
import RxRelay
import SwiftyJSON

class SKUListView: DDView {
    let clickSKUPublish = PublishRelay<JSON>()
    
    var SKUList = [JSON]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func createUI() {
        super.createUI()
        let topLine = UIView()
        topLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLine.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = ThemeColor.line.color()
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(mTableView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
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
        tTableView.register(SKUListTableViewCell.self, forCellReuseIdentifier: "SKUListTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

    
}

extension SKUListView {
    func _bindView() {
        _ = self.mTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mTableView.snp.updateConstraints { (make) in
                    make.height.equalTo(contentSize.height)
            }
        })
    }
}

extension SKUListView {
    func reloadData() {
        self.mTableView.reloadData()
    }
}

extension SKUListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SKUList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SKUListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SKUListTableViewCell") as! SKUListTableViewCell
        cell.selectionStyle = .none
        let model = self.SKUList[indexPath.row]
        cell.updateUI(model: model)
        if indexPath.row == 0 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            self.clickSKUPublish.accept(model)
        }
        return cell
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
        let model = self.SKUList[indexPath.row]
        self.clickSKUPublish.accept(model)
    }
}
