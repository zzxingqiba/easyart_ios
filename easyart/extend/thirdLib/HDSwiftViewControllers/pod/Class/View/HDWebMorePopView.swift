//
//  HDWebMorePopView.swift
//  HDSwiftViewControllers
//
//  Created by Damon on 2021/2/28.
//  Copyright © 2021 Damon. All rights reserved.
//

import UIKit
import DDUtils
import RxSwift

class HDWebMorePopView: UIView {
    private var mDataSource = [HDWebPopCollectionViewCellModel]()
    let mCancelSubject = PublishSubject<Void>()
    let mItemClickSubject = PublishSubject<Int>()
    private var isDark = false

    init(isDark: Bool) {
        super.init(frame: .zero)
        self.isDark = isDark
        self.p_createUI()
        self.p_loadData()
        self.p_bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = self.isDark ? UIColor.dd.color(hexValue: 0xffffff, alpha: 0.8) : UIColor.dd.color(hexValue: 0x999999)
        tLabel.textAlignment = .center
        tLabel.font = .systemFont(ofSize: 12)
        return tLabel
    }()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 70, height: 90)

        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = true
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(HDWebPopCollectionViewCell.self, forCellWithReuseIdentifier: "HDWebPopCollectionViewCell")
        return tCollection
    }()
    
    lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setTitle("取消".ZXLocaleString, for: .normal)
        tButton.setTitleColor(self.isDark ? UIColor.dd.color(hexValue: 0xffffff, alpha: 0.9) : UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.backgroundColor = self.isDark ? UIColor.dd.color(hexValue: 0x333333) :  UIColor.dd.color(hexValue: 0xffffff)
        tButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return tButton
    }()
}

extension HDWebMorePopView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mDataSource.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HDWebPopCollectionViewCell", for: indexPath) as! HDWebPopCollectionViewCell
        cell.updateUI(model: mDataSource[indexPath.item])
        cell.mTitleLabel.textColor = self.isDark ? UIColor.dd.color(hexValue: 0xffffff, alpha: 0.7) : UIColor.dd.color(hexValue: 0x666666)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mItemClickSubject.onNext(indexPath.item)
    }

}

private extension HDWebMorePopView {
    func p_createUI() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backgroundColor = self.isDark ? UIColor.dd.color(hexValue: 0x1a1a1a) : UIColor.dd.color(hexValue: 0xF5F5F5)
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreenWidth)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(13)
        }
        
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(200)
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
            make.top.equalTo(mCollectionView.snp.bottom)
        }
    }
    
    func p_bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.mCancelSubject.onNext(())
        })
    }
    
    func p_loadData() {
        let model = HDWebPopCollectionViewCellModel(title: "投诉".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_concat"))
        let model2 = HDWebPopCollectionViewCellModel(title: "复制链接".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_link"))
        let model3 = HDWebPopCollectionViewCellModel(title: "刷新".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_refresh"))
        let model4 = HDWebPopCollectionViewCellModel(title: "搜索页面内容".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_search"))
        let model5 = HDWebPopCollectionViewCellModel(title: "safari打开".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_safari"))
        let model6 = HDWebPopCollectionViewCellModel(title: "生成二维码".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_qr"))
        let model7 = HDWebPopCollectionViewCellModel(title: "其他APP打开".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_app"))
        let model8 = HDWebPopCollectionViewCellModel(title: "清理缓存".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_tool"))
        let model9 = HDWebPopCollectionViewCellModel(title: "打印".ZXLocaleString, icon: UIImageHDVCBoundle(named: "icon_print"))
        
        self.mDataSource.append(model)
        self.mDataSource.append(model2)
        self.mDataSource.append(model3)
        self.mDataSource.append(model4)
        self.mDataSource.append(model5)
        self.mDataSource.append(model6)
        self.mDataSource.append(model7)
        self.mDataSource.append(model8)
        self.mDataSource.append(model9)
        self.mCollectionView.reloadData()
    }
}
