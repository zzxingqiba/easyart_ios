//
//  ArtistEditTipsImageListView.swift
//  easyart
//
//  Created by Damon on 2025/1/16.
//

import UIKit

class ArtistEditTipsImageListView: DDView {
    override func createUI() {
        super.createUI()
        self.addSubview(mScrollView)
        mScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mScrollView.addSubview(mContentView)
        mContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    //MARK UI
    lazy var mScrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()

    lazy var mContentView: UIView = {
        let view = UIView()
        return view
    }()
}

extension ArtistEditTipsImageListView {
    func updateImageList(images: [String]) {
        for view in mContentView.subviews {
            view.removeFromSuperview()
        }
        var posView: UIView?
        for i in 0..<images.count {
            let imageUrl = images[i]
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.kf.setImage(with: URL(string: imageUrl))
            imageView.backgroundColor = UIColor.dd.color(hexValue: 0xE6E6E6)
            mContentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                if let view = posView {
                    make.left.equalTo(view.snp.right).offset(13)
                } else {
                    make.left.equalToSuperview()
                }
                make.width.height.equalTo(130)
            }
            if i == images.count - 1 {
                imageView.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-13)
                }
            }
            posView = imageView
        }
        
    }
}
