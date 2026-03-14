//
//  DDSearchDefaultView.swift
//  easyart
//
//  Created by Damon on 2024/11/22.
//

import UIKit
import DDUtils
import RxRelay
import SwiftyJSON

class DDSearchDefaultView: DDView {
    private var pageCur = 1
    private var hasMore = true
    var recentSearchModelList = [DDRecentSearchModel]()
    var recommendModelList = [ArtModel]()
    
    let imgClickPublish = PublishRelay<ArtModel>()
    let authorClickPublish = PublishRelay<ArtModel>()
    let recentClickPublish = PublishRelay<DDRecentSearchModel>()
    
    override func createUI() {
        super.createUI()
        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mContentView.addSubview(mRecentSearchLabel)
        mRecentSearchLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        mContentView.addSubview(mRecentSearchTableView)
        mRecentSearchTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mRecentSearchLabel)
            make.height.greaterThanOrEqualTo(50)
        }
        
        mContentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(mRecentSearchLabel)
            make.top.equalTo(mRecentSearchTableView.snp.bottom).offset(16)
        }
        
        mContentView.addSubview(mRecommendCollectionView)
        mRecommendCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var mContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mRecentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "No relevant search records".localString + " ……"
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mRecentSearchTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.isHidden = true
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
//        tTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDRecentSearchTableViewCell.self, forCellReuseIdentifier: "DDRecentSearchTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Recommended for you".localString
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mRecommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 42) / 2, height: (UIScreenWidth - 42) / 2 + 90)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.tag = 2
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()
}

extension DDSearchDefaultView {
    func loadData() {
//        let data = [
//            "page_find": 1,
//            "keyword":"",
//            "artist_ids":"",
//            "number_types": "",
//            "category_ids": "",
//            "min_price": self.searchModel.min_price,
//            "max_price": self.searchModel.max_price,
//            "min_length": self.searchModel.min_length,
//            "max_length": self.searchModel.max_length,
//            "min_width": self.searchModel.min_width,
//            "max_width": self.searchModel.max_width
//        ] as [String : Any]
        _ = DDAPI.shared.request("search/pageInfo", data: ["page_find":1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
//            self.mCollectionView.mj_header?.endRefreshing()
//            self.mCollectionView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = (data["recommend_list"].arrayObject as? [[String: Any]]) ?? []
            let list =  goodsList.kj.modelArray(ArtModel.self)
            if (self.pageCur == 1) {
                self.recommendModelList = list
            } else {
                self.recommendModelList.append(contentsOf: list)
            }
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            self.mRecommendCollectionView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
//            self.mCollectionView.mj_header?.endRefreshing()
//            self.mCollectionView.mj_footer?.endRefreshing()
        })
    }
    
    func _bindView() {
        _ = self.mRecentSearchTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mRecentSearchTableView.snp.updateConstraints { (make) in
                    make.height.greaterThanOrEqualTo(max(contentSize.height, 50))
            }
        })
        
        _ = self.mRecommendCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mRecommendCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(contentSize.height)
            }
        })
        
        _ = DDRecentSearchTools.shared.searchHistoryList.subscribe(onNext: { [weak self] modelList in
            guard let self = self else { return }
            self.mRecentSearchLabel.isHidden = modelList.count > 0
            self.mRecentSearchTableView.isHidden = modelList.count == 0
            self.recentSearchModelList = modelList.suffix(10)
            self.mRecentSearchTableView.reloadData()
        })
    }
    
    func _collect(collectionView: UICollectionView, indexPath: IndexPath) {
        let model: ArtModel = self.recommendModelList[indexPath.item]
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": model.goods_id, "type": model.is_collect ? 2 : 1]).subscribe(onSuccess: { response in
            let json = JSON(response.data)
            model.is_collect = !model.is_collect
            model.collect_num = json["goods_info"]["collect_num"].intValue
            collectionView.reloadItems(at: [indexPath])
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
}

extension DDSearchDefaultView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDRecentSearchTableViewCell") as! DDRecentSearchTableViewCell
        let model = recentSearchModelList[indexPath.row]
        cell.selectionStyle = .none
        cell.updateUI(model: model)
        cell.deleteClickPublish.subscribe(onNext: { _ in
            DDRecentSearchTools.shared.removeSearchModel(model: model)
        }).disposed(by: cell.disposeBag)
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
        let model = recentSearchModelList[indexPath.row]
        self.recentClickPublish.accept(model)
    }
}

extension DDSearchDefaultView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = recommendModelList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        cell.favClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //收藏
            self._collect(collectionView: collectionView, indexPath: indexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //跳转
            self.authorClickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        
        cell.imgClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //跳转
            self.imgClickPublish.accept(model)
        }).disposed(by: cell.disposeBag)
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
