//
//  ArtistEditRarityCollectionViewCell.swift
//  easyart
//
//  Created by Damon on 2025/1/17.
//

import UIKit
import RxRelay

class ArtistEditRarityCollectionViewCell: DDCollectionViewCell {
    let clickPublish = PublishRelay<Void>()
    let deletePublish = PublishRelay<Void>()
    
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        self.contentView.addSubview(mDeleteButton)
        mDeleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.mTitleLabel.snp.right)
            make.centerY.equalTo(self.mTitleLabel.snp.top)
            make.width.height.equalTo(20)
        }
        
        self._bindView()
    }
    
    func updateUI(text: String) {
        mTitleLabel.text = text
    }
    
    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = ThemeColor.black.color()
        label.layer.borderWidth = 0.5
        label.layer.borderColor = ThemeColor.line.color().cgColor
        return label
    }()
    
    lazy var mDeleteButton: DDButton = {
        let button = DDButton()
        button.contentType = .center(gap: 0)
        button.normalImage = UIImage(named: "me_cha2")
        button.imageSize = CGSize(width: 15, height: 15)
        return button
    }()
}

extension ArtistEditRarityCollectionViewCell {
    func _bindView() {
        let tap = UITapGestureRecognizer()
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.clickPublish.accept(())
        })
        self.addGestureRecognizer(tap)
        
        _ = self.mDeleteButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.deletePublish.accept(())
        })
    }
}
