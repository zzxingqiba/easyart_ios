//
//  DDGoodsNumberPopView.swift
//  easyart
//
//  Created by Damon on 2024/9/19.
//

import UIKit
import DDUtils
import SwiftyJSON
import RxSwift
import DDLoggerSwift

class DDGoodsNumberPopView: DDView {
    let mClickSubject = PublishSubject<DDPopButtonClickInfo>()
    var title: String
    var numberList: [JSON]
    private var mSelectedModel: JSON?
    
    init(title: String, numberList: [JSON]) {
        self.title = title
        self.numberList = numberList
        super.init(frame: .zero)
        self._bindView()
        self._loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createUI() {
        super.createUI()
        self.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        self.snp.makeConstraints { make in
            make.width.equalTo(UIScreenWidth)
            make.height.equalTo(500)
        }
        
        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(mCloseButton)
        mCloseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(mTitleLabel)
            make.width.height.equalTo(30)
        }
        
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        self.addSubview(mConfirmButton)
        mConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(mCollectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50 + BottomSafeAreaHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.gray.color()
        return label
    }()
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: (UIScreenWidth - 7) / 6, height: (UIScreenWidth - 7) / 6)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(DDGoodsNumbeCollectionViewCell.self, forCellWithReuseIdentifier: "DDGoodsNumbeCollectionViewCell")
        return tCollection
    }()
    
    lazy var mCloseButton: DDButton = {
        let button = DDButton()
        button.normalImage = UIImage(named: "home_guanbi")
        button.imageSize = CGSizeMake(16, 16)
        return button
    }()
    
    lazy var mConfirmButton: DDButton = {
        let button = DDButton(imagePosition: .none)
        button.contentType = .center(gap: 0)
        button.mTitleLabel.text = "Confirm".localString
        button.mTitleLabel.font = .systemFont(ofSize: 14)
        button.mTitleLabel.textColor = UIColor.dd.color(hexValue: 0xffffff)
        button.backgroundColor = ThemeColor.black.color()
        return button
    }()

}

extension DDGoodsNumberPopView {
    func _bindView() {
        _ = self.mCloseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mClickSubject.onNext(.init(clickType: .close, info: nil))
        })
        
        _ = self.mConfirmButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let selectedModel = mSelectedModel {
                self.mClickSubject.onNext(.init(clickType: .confirm, info: selectedModel))
            }
        })
    }
    
    func _loadData() {
        self.mTitleLabel.text = self.title
        self.mCollectionView.reloadData()
    }
}

extension DDGoodsNumberPopView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = numberList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDGoodsNumbeCollectionViewCell", for: indexPath) as! DDGoodsNumbeCollectionViewCell
//        if model["status"].intValue == 0 {
//            cell.backgroundColor = UIColor.clear
//        } else {
//            cell.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
//        }
        cell.updateUI(title: model["number_val"].stringValue)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        printLog("shouldSelectItemAt")
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = numberList[indexPath.item]
//        if  model["status"].intValue == 0 {
//            self.mSelectedModel = model
//        }
        self.mSelectedModel = model
    }
}
