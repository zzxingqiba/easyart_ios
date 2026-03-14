//
//  ArtistEditPreviewImageItemView.swift
//  easyart
//
//  Created by Damon on 2025/1/24.
//

import UIKit

class ArtistEditPreviewImageItemView: DDView {
    var imageList: [String] = [] {
        didSet {
            self.mCollectionView.reloadData()
        }
    }
    
    override func createUI() {
        self.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self._bindView()
    }
    
    //MARK: UI
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: 35, height: 35)
        let tCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        tCollection.allowsMultipleSelection = false
        tCollection.showsVerticalScrollIndicator = false
        tCollection.backgroundColor = UIColor.clear
        tCollection.delegate = self
        tCollection.dataSource = self
        tCollection.isScrollEnabled = false
        tCollection.register(ArtistEditPreviewImageItemCell.self, forCellWithReuseIdentifier: "ArtistEditPreviewImageItemCell")
        return tCollection
    }()
}

extension ArtistEditPreviewImageItemView {
    func _bindView() {
        _ = self.mCollectionView.rx.observe(CGSize.self, "contentSize").subscribe(onNext: { [weak self] (contentSize) in
            guard let self = self, let contentSize = contentSize else { return }
                self.mCollectionView.snp.updateConstraints { (make) in
                    make.height.equalTo(max(1, contentSize.height))
                }
        })
    }
}

extension ArtistEditPreviewImageItemView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = imageList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistEditPreviewImageItemCell", for: indexPath) as! ArtistEditPreviewImageItemCell
        cell.updateUI(imageUrl: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
}
