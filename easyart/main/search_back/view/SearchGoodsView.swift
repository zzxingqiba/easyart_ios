//
//  SearchGoodsView.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class SearchGoodsView: DDView {
    let clickPublish = PublishRelay<ArtModel>()
    private var pageCur = 1
    private var hasMore = true
    var name = "" {
        didSet {
            self.reloadData()
        }
    }
    var categoryID: String? {
        didSet {
            self.reloadData()
        }
    }
    var sizeID: String? {
        didSet {
            self.reloadData()
        }
    }
    var priceID: String? {
        didSet {
            self.reloadData()
        }
    }
    var list = [ArtModel]()
    
    override func createUI() {
        super.createUI()
        
        self.addSubview(mTopCategoryView)
        mTopCategoryView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.height.equalTo(40)
        }
        
        self.addSubview(mTopSizeView)
        mTopSizeView.snp.makeConstraints { make in
            make.left.right.equalTo(mTopCategoryView)
            make.top.equalTo(mTopCategoryView.snp.bottom).offset(8)
            make.height.equalTo(mTopCategoryView)
        }
        
        self.addSubview(mTopPriceView)
        mTopPriceView.snp.makeConstraints { make in
            make.left.right.equalTo(mTopSizeView)
            make.top.equalTo(mTopSizeView.snp.bottom).offset(8)
            make.height.equalTo(mTopSizeView)
        }
        
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(mTopCategoryView)
            make.top.equalTo(mTopPriceView.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
        
        //更新数据
        self._bindView()
        self.loadData()
    }
    
    //MARK: UI
    lazy var mTopCategoryView: DDCategoryView = {
        let view = DDCategoryView()
        return view
    }()
    
    lazy var mTopSizeView: DDCategoryView = {
        let view = DDCategoryView()
        return view
    }()
    
    lazy var mTopPriceView: DDCategoryView = {
        let view = DDCategoryView()
        return view
    }()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 48) / 2, height: (UIScreenWidth - 48) / 2 + 90)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()
    
}

extension SearchGoodsView {
    func updateUI(category: [JSON], size: [JSON], price: [JSON]) {
        mTopCategoryView.updateUI(items: category)
        mTopSizeView.updateUI(items: size)
        mTopPriceView.updateUI(items: price)
    }
    
    func reloadData() {
        self.pageCur = 1
        self.loadData()
    }
    
    func _loadRecomendData() {
        _ = DDAPI.shared.request("goods/recommendList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let data = JSON(response.data)
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            self.list =  goodsList.kj.modelArray(ArtModel.self)
            self.mCollectionView.reloadData()
        })
    }
    
    func loadData() {
        _ = DDAPI.shared.request("search/goodsList", data: ["page_find": self.pageCur, "name": self.name, "category_id": self.categoryID ?? "", "size_id": self.sizeID ?? "", "price_id": self.priceID ?? ""]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
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
            self.mCollectionView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
        })
    }
}

extension SearchGoodsView {
    func _collect(indexPath: IndexPath) {
        var model: ArtModel
        model = self.list[indexPath.row]
        _ = DDAPI.shared.request("goods/collect", data: ["goods_id": model.goods_id, "type": model.is_collect ? 2 : 1]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            model.is_collect = !model.is_collect
            model.collect_num = json["goods_info"]["collect_num"].intValue
            self.mCollectionView.reloadItems(at: [indexPath])
            //更新状态
            DDUserTools.shared.updateCollect(isNew: json["user_info"]["collect_new"].boolValue, number: json["user_info"]["collect_num"].stringValue)
        })
    }
    
    
    
    func _bindView() {
        _ = DDServerConfigTools.shared.configInfo.subscribe(onNext: { [weak self] config in
            guard let self = self else { return }
            let category_list = config["category_list"].arrayValue
            let size_list = config["size_list"].arrayValue
            let price_list = config["price_list"].arrayValue
            //更新分类
            self.updateUI(category: category_list, size: size_list, price: price_list)
        })
        
        self.mCollectionView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self.loadData()
        }
        self.mCollectionView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self.loadData()
            } else {
                self.mCollectionView.mj_footer?.endRefreshing()
            }
        }
        
        _ = self.mTopCategoryView.mClickSubject.subscribe(onNext: { [weak self] categoryID in
            guard let self = self else { return }
            self.categoryID = categoryID
        })
        
        _ = self.mTopSizeView.mClickSubject.subscribe(onNext: { [weak self] sizeID in
            guard let self = self else { return }
            self.sizeID = sizeID
            
        })
        
        _ = self.mTopPriceView.mClickSubject.subscribe(onNext: { [weak self] priceID in
            guard let self = self else { return }
            self.priceID = priceID
        })
    }
}

extension SearchGoodsView: UICollectionViewDelegate, UICollectionViewDataSource {
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
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}


