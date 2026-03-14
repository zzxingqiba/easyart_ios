//
//  DDLanguagePopView.swift
//  HiTalk
//
//  Created by Damon on 2024/8/6.
//

import UIKit
import DDUtils
import SwiftyJSON
import RxSwift

class DDLanguagePopView: DDView {
    let mClickSubject = PublishSubject<DDPopButtonClickInfo>()
    private var countryList: [JSON] = []
    
    override func createUI() {
        super.createUI()
        self.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(400)
        }
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.right.bottom.equalToSuperview()
        }
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
        }
        self._bindView()
        self._loadData()
    }
    
    //MARK: UI
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 150, height: 60)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.layer.cornerRadius = 10
        tCollection.layer.masksToBounds = true
        tCollection.register(DDLanguageCollectionViewCell.self, forCellWithReuseIdentifier: DDLanguageCollectionViewCell.dd.className())
        return tCollection
    }()

    lazy var mCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-close-white"), for: .normal)
        return button
    }()
}

extension DDLanguagePopView {
    func _loadData() {
        _ = DDAPI.shared.request("config/langList").subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            let json = JSON(response.data)
            self.countryList = json["lang_list"].arrayValue
            self.mCollectionView.reloadData()
        })
    }
    
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .close, info: nil))
        })
    }
}

extension DDLanguagePopView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = countryList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DDLanguageCollectionViewCell.dd.className(), for: indexPath) as! DDLanguageCollectionViewCell
        cell.updateUI(icon: model["icon_url"].stringValue, title: model["lang_code"].stringValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.countryList[indexPath.item]
        self.mClickSubject.onNext(DDPopButtonClickInfo(clickType: .confirm, info: model["lang_code"].stringValue))
        
    }
}
