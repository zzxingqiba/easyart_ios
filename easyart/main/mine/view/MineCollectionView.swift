//
//  MineCollectionView.swift
//  easyart
//
//  Created by 崭新的旧刀 on 2026/3/18.
//

//
//  MeCollectionView.swift
//  easyart
//
//  Created by Damon on 2025/1/7.
//

import UIKit
import DDUtils
import SwiftyJSON
import MJRefresh

class MineCollectionView: DDView {
    private var pageCur = 1
    private var hasMore = true
    private var list = [ArtModel]() {
        didSet {
            self.mEmptyLebl.isHidden = !list.isEmpty
            self.mEmptyButton.isHidden = !list.isEmpty
            self.mCollectionView.isHidden = list.isEmpty
        }
    }

    override func createUI() {
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(300)
        }
        
        self.addSubview(mEmptyLebl)
        mEmptyLebl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        self.addSubview(mEmptyButton)
        mEmptyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mEmptyLebl.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: (UIScreenWidth - 48) / 2, height: (UIScreenWidth - 48) / 2 + 70)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: "ArtCollectionViewCell")
        return tCollection
    }()
    
    lazy var mEmptyLebl: UILabel = {
        let label = UILabel()
        label.text = "You haven't purchased any works yet".localString
        label.font = .systemFont(ofSize: 13)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mEmptyButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .contentFit(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), gap: 0)
        button.mTitleLabel.text = "Browse now".localString
        button.mTitleLabel.font = .systemFont(ofSize: 13)
        button.mTitleLabel.textColor = ThemeColor.black.color()
        button.layer.borderColor = ThemeColor.black.color().cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        return button
    }()
}

extension MineCollectionView {
    func _bindView() {
        _ = DDUserTools.shared.userInfo.subscribe(onNext: {
            [weak self] userModel in
            guard let self = self else { return }
            print("========")
            loadData()
        })
            
            
        _ = self.mEmptyButton.rx.tap.subscribe(onNext: { _ in
            DDUtils.shared.getCurrentVC()?.tabBarController?.selectedIndex = 0
        })
        
        _ = self.mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(300, contentSize.height + 100))
                }
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
    }
    
    func loadData() {
        if DDUserTools.shared.userInfo.value.role.user_role == 1 || DDUserTools.shared.userInfo.value.role.status != 1 {
            self.list = []
            self.mCollectionView.reloadData()
        } else {
            _ = DDAPI.shared.request("goods/buyList", data: ["page_find": self.pageCur]).subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.mCollectionView.mj_header?.endRefreshing()
                self.mCollectionView.mj_footer?.endRefreshing()
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
            })
        }
        
    }
}

extension MineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = list[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtCollectionViewCell", for: indexPath) as! ArtCollectionViewCell
        
        cell.imgClickPublish.subscribe(onNext: { _ in
            let vc = DetailVC(goodsID: model.goods_id)
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        
        cell.authorClickPublish.subscribe(onNext: { _ in
            let vc = DDAuthorDetailVC(id: model.artist_id)
            vc.hidesBottomBarWhenPushed = true
            DDUtils.shared.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: cell.disposeBag)
        
        cell.updateUI(model: model)
        
        cell.mFavButton.isHidden = true
        cell.mPriceLabel.isHidden = true
        cell.mSoldOutView.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
