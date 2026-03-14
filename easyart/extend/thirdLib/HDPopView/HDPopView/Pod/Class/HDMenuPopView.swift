//
//  HDMenuPopView.swift
//  HDPopView
//
//  Created by Damon on 2022/11/14.
//

import UIKit
import DDUtils
import RxSwift

open class HDMenuPopView: HDPopContentView {
    private var mDataSource = [HDMenuPopItem]()
    private let mItemClickSubject = PublishSubject<Int>()
    private var itemWidth: CGFloat = 80 //80一排4个，70一排5个

    public init(title: String?, itemList: [HDMenuPopItem] = [], itemWidth: CGFloat = 80) {
        self.itemWidth = itemWidth
        super.init(frame: .zero)
        self._createUI()
        self._bindView()
        //更新title
        self.mTitleLabel.text = title
        self.updateItem(itemList: itemList)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateItem(itemList: [HDMenuPopItem]) {
        self.mDataSource = itemList
        self.mCollectionView.reloadData()
    }

    //MARK: Lazy
    public private(set) lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.textColor = UIColor.dd.color(hexValue: 0x000000)
        tLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tLabel.textAlignment = .center
        return tLabel
    }()

    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: self.itemWidth, height: 90)

        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = true
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.register(HDMenuCollectionViewCell.self, forCellWithReuseIdentifier: HDMenuCollectionViewCell.dd.className())
        return tCollection
    }()

    lazy var mCloseButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.setTitle(NSLocalizedString("关闭", comment: ""), for: .normal)
        tButton.setTitleColor(UIColor.dd.color(hexValue: 0x333333), for: .normal)
        tButton.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        tButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return tButton
    }()

}

extension HDMenuPopView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mDataSource.count
    }


    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HDMenuCollectionViewCell.dd.className(), for: indexPath) as! HDMenuCollectionViewCell
        cell.updateUI(model: mDataSource[indexPath.item])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mItemClickSubject.onNext(indexPath.item)
    }
}

private extension HDMenuPopView {
    func _createUI() {
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.backgroundColor = UIColor.dd.color(hexValue: 0xF5F5F5)
        self.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreenWidth)
        }

        self.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }

        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(mTitleLabel.snp.bottom).offset(30)
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

    func _bindView() {
        _ = self.mCloseButton.rx.tap.map { _ in
            return HDPopButtonClickInfo(clickType: .cancel)
        }.bind(to: self.clickBinder)

        _ = self.mItemClickSubject.map { index in
            return HDPopButtonClickInfo(clickType: .custom, info: index)
        }.bind(to: self.clickBinder)
    }
}
