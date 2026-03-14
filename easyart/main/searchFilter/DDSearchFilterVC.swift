//
//  DDSearchFilterVC.swift
//  easyart
//
//  Created by Damon on 2024/11/25.
//

import UIKit

class DDSearchFilterVC: BaseVC {
    private var searchModel: DDSearchModel
    private var list: [DDSearchFilterModel] = []
    
    init(searchModel: DDSearchModel) {
        self.searchModel = searchModel
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mSafeView.addSubview(mRecentSearchTableView)
        mRecentSearchTableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mSearchFilterBottomView)
        mSearchFilterBottomView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._loadData()
    }

    //MARK: UI
    lazy var mRecentSearchTableView: UITableView = {
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
        tTableView.register(DDSearchFilterTableViewCell.self, forCellReuseIdentifier: "DDSearchFilterTableViewCell")
        tTableView.rowHeight = 50
        return tTableView
    }()
    
    lazy var mSearchFilterBottomView: DDSearchFilterBottomView = {
        let view = DDSearchFilterBottomView()
        view.mClearButton.mTitleLabel.text = "Clear All".localString
        return view
    }()
}

extension DDSearchFilterVC {
    func _loadData() {
        self.list = []
        let item = DDSearchFilterModel(title: "Artists".localString, tag: self.searchModel.artist_ids.count)
        self.list.append(item)
        
        let item1 = DDSearchFilterModel(title: "Rarity".localString, tag: self.searchModel.number_types.count)
        self.list.append(item1)
        
        let item2 = DDSearchFilterModel(title: "Medium".localString, tag: self.searchModel.category_ids.count)
        self.list.append(item2)
        
        let item3 = DDSearchFilterModel(title: "Price".localString, tag: self.searchModel.getPriceTag())
        self.list.append(item3)
        
        let item4 = DDSearchFilterModel(title: "Size".localString, tag: self.searchModel.getSizeTag())
        self.list.append(item4)
        
        self.mRecentSearchTableView.reloadData()
    }
    
    func _bindView() {
        _ = self.mSearchFilterBottomView.confirmPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        _ = self.mSearchFilterBottomView.clearPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.searchModel.reset()
            self._loadData()
        })
    }
}

extension DDSearchFilterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDSearchFilterTableViewCell") as! DDSearchFilterTableViewCell
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
        if indexPath.row == 0 {
            let vc = DDSearchArtistsFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = DDSearchRarityFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = DDSearchMediumFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = DDSearchPriceFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }  else if indexPath.row == 4 {
            let vc = DDSearchSizeFilterVC(searchModel: self.searchModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
