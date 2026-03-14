//
//  DDCollectionListVC.swift
//  easyart
//
//  Created by Damon on 2024/9/23.
//

import UIKit
import RxRelay
import SwiftyJSON
import MJRefresh
import DDUtils

class DDCollectionListVC: BaseVC {
    var pageCur = 1
    var hasMore = true
    var list = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBarTitle(title: "Like".localString, textColor: ThemeColor.black.color())
        self._bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageCur = 1
        self._loadData()
    }
    
    override func createUI() {
        super.createUI()
        self.mSafeView.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mSafeView.addSubview(mEmptyImageView)
        mEmptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(70)
            make.height.equalTo(38)
        }
    }
    
    //MARK: UI
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreenWidth / 3, height: UIScreenWidth / 3)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(DDFavCollectionViewCell.self, forCellWithReuseIdentifier: "DDFavCollectionViewCell")
        return tCollection
    }()
    
    lazy var mEmptyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "me_noData"))
        return imageView
    }()
}

extension DDCollectionListVC {
    func _bindView() {
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
                self.mCollectionView.mj_footer?.endRefreshing()
            }
        }
    }
    
    func _loadData() {
        _ = DDAPI.shared.request("goods/collectList", data: ["page_find": self.pageCur]).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
            //处理数据
            let data = JSON(response.data)
            let goodsList = data["goods_list"].arrayValue
            if (self.pageCur == 1) {
                self.list = goodsList
            } else {
                self.list.append(contentsOf: goodsList)
            }
            self.mEmptyImageView.isHidden = !self.list.isEmpty
            self.hasMore = data["has_more"].boolValue
            self.pageCur = data["page_curr"].intValue
            self.mCollectionView.reloadData()
            DDUserTools.shared.updateCollect(isNew: data["collect_new"].boolValue)
        }, onFailure: { [weak self] _ in
            guard let self = self else { return }
            self.mCollectionView.mj_header?.endRefreshing()
            self.mCollectionView.mj_footer?.endRefreshing()
        })
    }
}

extension DDCollectionListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDFavCollectionViewCell", for: indexPath) as! DDFavCollectionViewCell
        cell.updateUI(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = list[indexPath.item]
        let vc = DetailVC(goodsID: model["goods_id"].stringValue)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
