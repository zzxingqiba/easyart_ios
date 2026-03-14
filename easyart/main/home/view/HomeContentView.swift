//
//  HomeContentView.swift
//  easyart
//
//  Created by Damon on 2024/9/9.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class HomeContentView: DDView {
    let clickPublish = PublishRelay<ArtModel>()
    let authorClickPublish = PublishRelay<ArtModel>()
    
    
    var showDouble = false {
        didSet {
            self.mTableView.isHidden = showDouble
            self.mCollectionView.isHidden = !showDouble
            self._reloadData()
        }
    }
    private var pageCur = 1
    private var hasMore = true
    private var list = [ArtModel]()
    private var sortTypeID = 0
    override func createUI() {
        super.createUI()
        self.addSubview(mHomeNavView)
        mHomeNavView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mHomeNavView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(mTableView)
        mTableView.snp.makeConstraints { make in
            make.top.equalTo(mHomeNavView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
        self._loadData()
    }

    //MARK: UI
    lazy var mHomeNavView: HomeNavView = {
        let view = HomeNavView()
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
        tTableView.register(ArtTableViewCell.self, forCellReuseIdentifier: "ArtTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 36) / 2, height: (UIScreenWidth - 36) / 2 + 90)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.isHidden = true
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()
}

extension HomeContentView {
    func reloadData() {
        self.pageCur = 1
        self._loadData()
    }
}

extension HomeContentView {
    func _bindView() {
        _ = self.mHomeNavView.clickPublish.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            if index == 0 {
                self.showDouble = false
            } else if index == 1 {
                self.showDouble = true
            } else if index == 2 {
                //显示弹窗
                let pop = HomeGoodsSortTypePop()
                pop.selectedID = self.sortTypeID
                _ = pop.clickPublish.subscribe(onNext: { [weak self] homeGoodsSortType in
                    guard let self = self else { return }
                    DDPopView.hide()
                    self.sortTypeID = homeGoodsSortType.id
                    self.pageCur = 1
                    self.hasMore = true
                    self._loadData()
                })
                DDPopView.show(view: pop, animationType: .bottom)
                DDPopView.mShouldCloseIfClickBG = true
            }
        })
        
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
                self.mCollectionView.mj_footer?.endRefreshing()
            }
        }
        
        self.mCollectionView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self._loadData()
        }
        self.mCollectionView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self._loadData()
            } else {
                self.mTableView.mj_footer?.endRefreshing()
                self.mCollectionView.mj_footer?.endRefreshing()
            }
        }
    }
    
    func _loadData() {
        var data = ["page_find": self.pageCur]
        if self.sortTypeID == 1 {
            data["price_type"] = 1
        } else if self.sortTypeID == 2 {
            data["price_type"] = 2
        } else if self.sortTypeID == 3 {
            data["year_type"] = 1
        } else if self.sortTypeID == 4 {
            data["year_type"] = 2
        } else if self.sortTypeID == 5 {
            data["update_type"] = 1
        }
        _ = DDAPI.shared.request("goods/goodsList", data: data).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            let list =  goodsList.kj.modelArray(ArtModel.self)
            if (self.pageCur == 1) {
                self.list = list
            } else {
                self.list.append(contentsOf: list)
            }
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            DispatchQueue.main.async {
                self._reloadData()
            }
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mTableView.mj_header?.endRefreshing()
            self.mTableView.mj_footer?.endRefreshing()
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
        })
    }
    
    func _reloadData(indexPath: IndexPath? = nil) {
        if let indexPath = indexPath {
            self.mCollectionView.reloadItems(at: [indexPath])
            self.mTableView.reloadRows(at: [indexPath], with: .none)
        } else {
            self.mCollectionView.reloadData()
            self.mTableView.reloadData()
        }
    }
    
    func _collect(indexPath: IndexPath) {
        var model: ArtModel
        if self.showDouble {
            model = self.list[indexPath.item]
        } else {
            model = self.list[indexPath.row]
        }
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": model.goods_id, "type": model.is_collect ? 2 : 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            model.is_collect = !model.is_collect
            model.collect_num = json["goods_info"]["collect_num"].intValue
            self._reloadData(indexPath: indexPath)
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
}

extension HomeContentView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArtTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtTableViewCell") as! ArtTableViewCell
        cell.selectionStyle = .none
        let model = self.list[indexPath.row]
        cell.favClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._collect(indexPath: indexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.imgClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.authorClickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        
        cell.updateUI(model: model, tableView: tableView)
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
        
    }
}

extension HomeContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        cell.favClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self._collect(indexPath: indexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.imgClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.authorClickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
