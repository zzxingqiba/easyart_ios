//
//  ArtistEditPreviewImageItemCell.swift
//  easyart
//
//  Created by Damon on 2025/1/24.
//

import UIKit

class ArtistEditPreviewImageItemCell: DDCollectionViewCell {
    override func createUI() {
        super.createUI()
        self.contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateUI(imageUrl: String) {
        mImageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    //MARK: UI
    lazy var mImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = ThemeColor.line.color()
        return view
    }()
}
