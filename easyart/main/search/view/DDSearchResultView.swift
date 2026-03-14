//
//  DDSearchResultView.swift
//  easyart
//
//  Created by Damon on 2024/11/22.
//

import UIKit
import DDUtils
import SwiftyJSON
import MJRefresh
import RxRelay

class DDSearchResultView: DDView {
    var searchModel = DDSearchModel()
    let resultClickPublish = PublishRelay<DDRecentSearchModel>()
    let authorClickPublish = PublishRelay<String>()
    let resetClickPublish = PublishRelay<Void>()
    
    var artistSearchModelList = [DDArtistSearchModel]()
    var searchModelList = [ArtModel]()
    private var pageCur = 1
    private var hasMore = true
    
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
            make.height.greaterThanOrEqualTo(1)
        }
        
        mContentView.addSubview(mSearchEmptyView)
        mSearchEmptyView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.right.equalToSuperview()
        }
        
        mContentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
        mContentView.addSubview(mArtistSearchTableView)
        mArtistSearchTableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
        }
        
        mContentView.addSubview(mArtTitleLabel)
        mArtTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mArtistSearchTableView.snp.bottom).offset(16)
        }
        mContentView.addSubview(mSearchCollectionView)
        mSearchCollectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(mArtTitleLabel.snp.bottom).offset(16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        self._bindView()
        self._addHeader()
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
    
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Artists".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mArtistSearchTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.tag = 2
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .none
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.showsVerticalScrollIndicator = false
        tTableView.register(DDArtistSearchTableViewCell.self, forCellReuseIdentifier: "DDArtistSearchTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()
    
    lazy var mArtTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Art Works".localString
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        return label
    }()
    
    lazy var mSearchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 42) / 2, height: (UIScreenWidth - 42) / 2 + 90)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.tag = 1
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()

    lazy var mSearchEmptyView: DDSearchEmptyView = {
        let emptyView = DDSearchEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
}

extension DDSearchResultView {
    func search(model: DDSearchModel) {
        self.searchModel = model
        self._loadData()
    }
}

extension DDSearchResultView {
    func _loadData() {
        let data = [
            "page_find": self.pageCur,
            "keyword": self.searchModel.keyword,
            "artist_ids": self.searchModel.getArtistIDs(),
            "number_types": self.searchModel.getNumberTypes(),
            "category_ids": self.searchModel.getCategoryIDs(),
            "min_price": self.searchModel.min_price ?? 0,
            "max_price": self.searchModel.max_price ?? 0,
            "size_range": self.searchModel.getSize(),
        ] as [String : Any]
        _ = DDAPI.shared.request("search/pageInfo", data: data).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mScrollView.endReresh()
            //处理数据
            let data = JSON(response.data)
            let artistList = (data["artist_list"].arrayObject as? [[String: Any]]) ?? []
            self.artistSearchModelList = artistList.kj.modelArray(DDArtistSearchModel.self)
            //商品数据
            let goodsList = (data["goods_list"].arrayObject as? [[String: Any]]) ?? []
            let list =  goodsList.kj.modelArray(ArtModel.self)
            if (self.pageCur == 1) {
                self.searchModelList = list
            } else {
                self.searchModelList.append(contentsOf: list)
            }
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            self.mTitleLabel.isHidden = self.artistSearchModelList.count == 0
            self.mArtTitleLabel.isHidden = self.searchModelList.count == 0
            self.mSearchEmptyView.isHidden = !(self.artistSearchModelList.count == 0 && self.searchModelList.count == 0)
            if self.mSearchEmptyView.isHidden  {
                self.mContentView.snp.updateConstraints { make in
                    make.height.greaterThanOrEqualTo(1)
                }
            } else {
                self.mContentView.snp.updateConstraints { make in
                    make.height.greaterThanOrEqualTo(350)
                }
            }
            self.mArtistSearchTableView.reloadData()
            self.mSearchCollectionView.reloadData()
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mScrollView.endReresh()
        })
    }
    
    func _addHeader(){
        self.mScrollView.addRefreshHeader { [weak self] in
            guard let self = self else { return }
            self.pageCur = 1
            self._loadData()
        }
        self.mScrollView.addRefreshFooter { [weak self] in
            guard let self = self else { return }
            if self.hasMore {
                self.pageCur = self.pageCur + 1
                self._loadData()
            } else {
                self.mScrollView.mj_footer?.endRefreshing()
            }
        }
    }
    
    func _bindView() {
        _ = self.mArtistSearchTableView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mArtistSearchTableView.snp.updateConstraints { (make) in
                    make.height.equalTo(contentSize.height)
            }
        })
        
        _ = self.mSearchCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mSearchCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(contentSize.height)
            }
        })

        _ = self.mSearchEmptyView.clickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.resetClickPublish.accept(())
        })
    }
    
    func _collect(collectionView: UICollectionView, indexPath: IndexPath) {
        let model: ArtModel = self.searchModelList[indexPath.item]
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

extension DDSearchResultView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artistSearchModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDArtistSearchTableViewCell") as! DDArtistSearchTableViewCell
        let model = artistSearchModelList[indexPath.row]
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
        let model = artistSearchModelList[indexPath.row]
        let recentModel = DDRecentSearchModel()
        recentModel.type = .author
        recentModel.id = model.id
        recentModel.image = model.face_url
        recentModel.title = model.name
        recentModel.des = model.country_name
        DDRecentSearchTools.shared.addSearchModel(model: recentModel)
        //
        self.resultClickPublish.accept(recentModel)
    }
}

extension DDSearchResultView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = searchModelList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        cell.favClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //收藏
            self._collect(collectionView: collectionView, indexPath: indexPath)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //跳转
            self.authorClickPublish.accept(model.artist_id)
        }).disposed(by: cell.disposeBag)
        
        cell.imgClickPublish.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            //跳转
            let recentModel = DDRecentSearchModel()
            recentModel.type = .goods
            recentModel.id = Int(model.goods_id) ?? 0
            recentModel.image = model.photo_url
            recentModel.title = model.name
            recentModel.des = model.artist_name
            DDRecentSearchTools.shared.addSearchModel(model: recentModel)
            //
            self.resultClickPublish.accept(recentModel)
        }).disposed(by: cell.disposeBag)
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
